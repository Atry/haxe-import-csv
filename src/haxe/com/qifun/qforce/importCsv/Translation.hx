package com.qifun.qforce.importCsv;
import haxe.macro.*;

class Translation
{

  static var STRING_MAPPING(default, never) =
  [
    "zh_CN.GBK" =>
    [
      "Unexpected access" =>
        "��֧�ֵ����η�",
      "Expect a string literal" =>
        "��Ҫ�ַ���������",
      "Expected `@meta` or `ItemId`" =>
        "��Ҫ`@meta`��`ItemId`",
      "Expected `function` or `var`" =>
        "��Ҫ`function`��`var`",
      "Property is not supported" =>
        "��֧������",
      "The function definition in first row must not include a function body" =>
        "����һ���еĺ������岻�ð���������",
      "The var definition in first row must not include a initializer" =>
        "����һ���еı������岻�ð�����ʼֵ",
    ]
  ];

  macro public static function translate(self:ExprOf<String>):ExprOf<String> return
  {
    switch (self)
    {
      case { expr: EConst(CString(origin)) }:
      {
        var locale = Context.definedValue("locale");
        if (locale == null)
        {
          self;
        }
        else
        {
          var mapping = STRING_MAPPING.get(locale);
          if (mapping == null)
          {
            self;
          }
          else
          {
            var translated = mapping.get(origin);
            if (translated == null)
            {
              self;
            }
            else
            {
              if (MacroStringTools.isFormatExpr(self))
              {
                MacroStringTools.formatString(translated, Context.currentPos());
              }
              else
              {
                Context.makeExpr(translated, Context.currentPos());
              }
            }
          }
        }
      }
      case { pos: p }:
      {
        Context.error(translate("Expect a string literal"), p);
      }
    }
  }

}
