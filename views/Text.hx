package views;

using views.Externs;


@:include("render_backend/skia/canvas.h")
@:native("sk_sp<fluxe::FontCollection>")
@:unreflective
extern class NativeFontCollection {
    @:native("sk_make_sp<fluxe::FontCollection>")
    public static function CreateNative():NativeFontCollection;
}

class FontCollection {
    public static function Create():NativeFontCollection {
        var collection = NativeFontCollection.CreateNative();
        untyped __cpp__("collection->setDefaultFontManager(SkFontMgr::RefDefault())");
        return collection;
    }
}


@:include("render_backend/skia/canvas.h")
@:native("fluxe::TextShadow")
@:unreflective
@:structAccess
extern class TextShadow {
    // @:native("fluxe::TextShadow")
    // public static function Create(color:Color, offset:Point, blurSigma:cpp.Float64):TextShadow;
}

class TextBox {
    public var left = 0.0;
    public var top = 0.0;
    public var right = 0.0;
    public var bottom = 0.0;

    public function new(left:Float, top:Float, right:Float, bottom:Float) {
        this.left = left;
        this.top = top;
        this.right = right;
        this.bottom = bottom;
    }
}

@:include("render_backend/skia/canvas.h")
@:native("fluxe::TextStyle")
@:unreflective
@:structAccess
extern class TextStyle {
    public function setColor(color:Color):Void;
    public function setForegroundColor(color:Color):Void;
    public function clearForegroundColor():Void;
    public function setBackgroundColor(color:Color):Void;
    public function clearBackgroundColor():Void;

    // void setDecoration(TextDecoration decoration) { fDecoration.fType = decoration; }
    // void setDecorationMode(TextDecorationMode mode) { fDecoration.fMode = mode; }
    // void setDecorationStyle(TextDecorationStyle style) { fDecoration.fStyle = style; }
    // void setDecorationColor(SkColor color) { fDecoration.fColor = color; }
    // void setDecorationThicknessMultiplier(SkScalar m) { fDecoration.fThicknessMultiplier = m; }
    // void setFontStyle(SkFontStyle fontStyle) { fFontStyle = fontStyle; }

    public function addShadow(shadow:TextShadow):Void;
    // void addFontFeature(const SkString& fontFeature, int value)
    public function setFontSize(size:cpp.Float64):Void;
    // void setFontFamilies(std::vector<SkString> families) {
    // SkScalar getBaselineShift() const { return fBaselineShift; }
    // void setBaselineShift(SkScalar baselineShift) { fBaselineShift = baselineShift; }
    // void setHeight(SkScalar height) { fHeight = height; }
    // SkScalar getHeight() const { return fHeightOverride ? fHeight : 0; }
    // void setHeightOverride(bool heightOverride) { fHeightOverride = heightOverride; }
    // bool getHeightOverride() const { return fHeightOverride; }
    // void setLetterSpacing(SkScalar letterSpacing) { fLetterSpacing = letterSpacing; }
    // void setTypeface(sk_sp<SkTypeface> typeface) { fTypeface = std::move(typeface); }
    // void setLocale(const SkString& locale) { fLocale = locale; }
    // TextBaseline getTextBaseline() const { return fTextBaseline; }
    // void setTextBaseline(TextBaseline baseline) { fTextBaseline = baseline; }
}

@:include("render_backend/skia/canvas.h")
@:native("fluxe::ParagraphStyle")
@:unreflective
@:structAccess
extern class ParagraphStyle {

    @:native("fluxe::ParagraphStyle")
    public static function Create():ParagraphStyle;

    // const StrutStyle& getStrutStyle() const { return fStrutStyle; }
    // void setStrutStyle(StrutStyle strutStyle) { fStrutStyle = std::move(strutStyle); }

    // const TextStyle& getTextStyle() const { return fDefaultTextStyle; }
    // void setTextStyle(const TextStyle& textStyle) { fDefaultTextStyle = textStyle; }
    // const TextStyle& getTextStyle() const { return fDefaultTextStyle; }
    public function setTextStyle(textStyle:TextStyle):Void;

    // TextDirection getTextDirection() const { return fTextDirection; }
    // void setTextDirection(TextDirection direction) { fTextDirection = direction; }

    // TextAlign getTextAlign() const { return fTextAlign; }
    // void setTextAlign(TextAlign align) { fTextAlign = align; }

    // size_t getMaxLines() const { return fLinesLimit; }
    // void setMaxLines(size_t maxLines) { fLinesLimit = maxLines; }

    // SkString getEllipsis() const { return fEllipsis; }
    // std::u16string getEllipsisUtf16() const { return fEllipsisUtf16; }
    // void setEllipsis(const std::u16string& ellipsis) {  fEllipsisUtf16 = ellipsis; }
    // void setEllipsis(const SkString& ellipsis) { fEllipsis = ellipsis; }

    // SkScalar getHeight() const { return fHeight; }
    // void setHeight(SkScalar height) { fHeight = height; }

    // TextHeightBehavior getTextHeightBehavior() const { return fTextHeightBehavior; }
    // void setTextHeightBehavior(TextHeightBehavior v) { fTextHeightBehavior = v; }

    // bool unlimited_lines() const {
    //     return fLinesLimit == std::numeric_limits<size_t>::max();
    // }
    // bool ellipsized() const { return !fEllipsis.isEmpty() || !fEllipsisUtf16.empty(); }
    // TextAlign effective_align() const;
    // bool hintingIsOn() const { return fHintingIsOn; }
    // void turnHintingOff() { fHintingIsOn = false; }
    // DrawOptions getDrawOptions() { return fDrawingOptions; }
    // void setDrawOptions(DrawOptions value) { fDrawingOptions = value; }
}

@:include("render_backend/skia/canvas.h")
@:native("std::vector<fluxe::TextBox>")
@:unreflective
extern class TextBoxList {
}

@:include("render_backend/skia/canvas.h")
@:native("std::unique_ptr<fluxe::Paragraph>")
@:unreflective
extern class Paragraph {
    public function layout(width:cpp.Float64):Void;
    public function paint(canvas:cpp.Pointer<NativeCanvas>, x:cpp.Float64, y:cpp.Float64):Void;

    public function getMaxWidth():cpp.Float64;
    public function getHeight():cpp.Float64;
    public function getMinIntrinsicWidth():cpp.Float64;
    public function getMaxIntrinsicWidth():cpp.Float64;
    public function getAlphabeticBaseline():cpp.Float64;
    public function getIdeographicBaseline():cpp.Float64;
    public function getLongestLine():cpp.Float64;
    public function didExceedMaxLines():Bool;

	public function getRectsForRange(start:cpp.UInt32, end:cpp.UInt32, rectHeightStyle:Dynamic, rectWidthStyle:Dynamic):TextBoxList;
    public function lineNumber():Int;

}

@:include("render_backend/skia/canvas.h")
@:native("fluxe::ParagraphBuilderImpl")
@:unreflective
@:structAccess
extern class ParagraphBuilder {

    @:native("fluxe::ParagraphBuilderImpl")
    public static function Create(style:ParagraphStyle, fontCollection:NativeFontCollection):ParagraphBuilder;

    // ParagraphBuilderImpl(const ParagraphStyle& style,
    //     sk_sp<FontCollection> fontCollection,
    //     std::unique_ptr<SkUnicode> unicode);

    // // Just until we fix all the code; calls icu::make inside
    // ParagraphBuilderImpl(const ParagraphStyle& style, sk_sp<FontCollection> fontCollection);

    // Push a style to the stack. The corresponding text added with AddText will
    // use the top-most style.
    public function pushStyle(style:TextStyle):Void;

    // Remove a style from the stack. Useful to apply different styles to chunks
    // of text such as bolding.
    // Example:
    //   builder.PushStyle(normal_style);
    //   builder.AddText("Hello this is normal. ");
    //
    //   builder.PushStyle(bold_style);
    //   builder.AddText("And this is BOLD. ");
    //
    //   builder.Pop();
    //   builder.AddText(" Back to normal again.");
    public function pop():Void;

    // TextStyle peekStyle() override;

    // // Adds text to the builder. Forms the proper runs to use the upper-most style
    // // on the style_stack.
    // void addText(const std::u16string& text) override;

    // // Adds text to the builder, using the top-most style on on the style_stack.
    // void addText(const char* text) override; // Don't use this one - going away soon
    // void addText(const char* text, size_t len) override;

    public function addText(text:String):Void;

    // void addPlaceholder(const PlaceholderStyle& placeholderStyle) override;

    // void setParagraphStyle(const ParagraphStyle& style) override;

    // Constructs a SkParagraph object that can be used to layout and paint the text to a SkCanvas.
    // std::unique_ptr<Paragraph> Build() override;
    public function Build():Paragraph;

    public function Reset():Void;
}

class Text extends View {

    public function new() {
        super();
    }

    public var text(default, set) = "";

    public function set_text(text:String):String {
        this.text = text;
        needsLayout = true;
        return text;
    }

    private var needsLayout = true;
    private var paragraph:Paragraph;
    
    public function getRectsForRange(start:Int, end:Int):Array<TextBox> {
        if (needsLayout) {
            buildAndMeasureText();
            needsLayout = false;
        }
        // RectHeightStyle.Tight, RectWidthStyle.Tight
        untyped __cpp__("auto rects = paragraph->getRectsForRange(start, end, skia::textlayout::RectHeightStyle::kTight, skia::textlayout::RectWidthStyle::kTight)");
        var hxRects:Array<TextBox> = [];
        untyped __cpp__("for (auto & rect : rects) { ::hx::ObjectPtr< TextBox_obj > box = TextBox_obj::__CreateEmpty(); box->__construct(rect.rect.left(), rect.rect.top(), rect.rect.right(), rect.rect.bottom()); hxRects->push(box); }");
        return hxRects;
        // return this.paragraph.getRectsForRange(start, end, untyped __cpp__("RectWidthStyle::kTight"), untyped __cpp__("RectHeightStyle::kTight"));
    }

    private function buildAndMeasureText() {
        var paragraphStyle = ParagraphStyle.Create();
        var fontCollection = FontCollection.Create();
        var builder = ParagraphBuilder.Create(paragraphStyle, fontCollection);
        builder.addText(this.text);

        paragraph = builder.Build();
        paragraph.layout(300);
        var height = paragraph.getHeight();
        var width = paragraph.getLongestLine();

        this.layoutSize = {
            width: width,
            height: height,
        };
    }

    public override function measureLayout() {
        if (needsLayout) {
            buildAndMeasureText();
            needsLayout = false;
        }
    }

    public override function build(builder:ViewBuilder) {
        // var paint = new Paint();
        // paint.setColor(new Color(0xFFFFFFFF));
        // var typeface = Typeface.MakeDefault();
        // var font = Font.Create(typeface, 12);
        // var blob = TextBlob.MakeFromString(this.text, font);

        // builder.canvas.drawTextBlob(blob, 0, 15, paint);
        this.paragraph.paint(builder.canvas._canvas, 0, 0);
    }
}