# encoding: utf-8

module Tests
  module Api
    module Lookup
      def setup
        super
        store_translations(:foo => { :bar => 'bar', :baz => 'baz' })
      end
      
      define_method "test lookup: given a nested key it looks up the nested hash value" do
        assert_equal 'bar', I18n.t(:'foo.bar')
      end

      define_method "test lookup: given a missing key, no default and no raise option it returns an error message" do
        assert_equal "translation missing: en, missing", I18n.t(:missing)
      end
      
      define_method "test lookup: given a missing key, no default and the raise option it raises MissingTranslationData" do
        assert_raises(I18n::MissingTranslationData) { I18n.t(:missing, :raise => true) }
      end

      define_method "test lookup: given an array of keys it translates all of them" do
        assert_equal %w(bar baz), I18n.t([:bar, :baz], :scope => [:foo])
      end

      define_method "test lookup: using a custom scope separator" do
        # data must have been stored using the custom separator when using the ActiveRecord backend
        I18n.backend.store_translations(:en, { :foo => { :bar => 'bar' } }, { :separator => '|' })
        assert_equal 'bar', I18n.t('foo|bar', :separator => '|')
      end

      define_method "test lookup: given nil as a locale it raises InvalidLocale" do
        assert_raises(I18n::InvalidLocale) { I18n.t(:bar, :locale => nil) }
      end
    end
  end
end
