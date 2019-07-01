Return-Path: <SRS0=mM2H=U6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE554C06511
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jul 2019 14:51:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4A332064B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jul 2019 14:51:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jdowjd3i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729808AbfGAOvK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 10:51:10 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41434 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728354AbfGAOvJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 10:51:09 -0400
Received: by mail-io1-f68.google.com with SMTP id w25so29401463ioc.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Jul 2019 07:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eMR7cQ1g+PqqgnBKWJ7soUssQCsSUciAr6Qgh4lmtl4=;
        b=jdowjd3iX1O2NoXT/nO8NKwVZh6OtWb5n5cAHuvGHCmeowfMygM8gPpEf8xGguGA+P
         VaR3V9AhXk4tBpHxHl9lBvi6CutboQK5AiNmcxOUhOCROkB8mxWkWHWQq1o9eH1Nq7z9
         4n9RZt/X4CF+BGMz1RjUT2pEAsstLamXAMw8J6GIy1Gc6MDCUBlsq2S3vxyZdQ9S825q
         6Ub+13divIbnz2goC2KK2kL0vG287LYkdo6DaJRSD1kNb5wI20PH/h0Kyxq2O0TBkvzY
         x/hcRuTTAlhlGi0nj+XaHgKoBXEU8I+X3DM/3Coj5bDdBpLZcYQdLiks3ve0/CHwjOYE
         YFMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eMR7cQ1g+PqqgnBKWJ7soUssQCsSUciAr6Qgh4lmtl4=;
        b=KzJ9feX927/kRmBBlyun/4m5BkGv4UGRX43aMQDcVaxPbig8s7TqENqY/sPW4uoxhq
         NHBuN4wL6iKVV9KWOBFvkqSI/wg4S+YaGu456zkGZd174BztfSBfHLTSeN1LI9BGS72m
         Du16f8/CxvySDv7Ossc3Ed3pgWUac13PUszPQ48aMfcwRgXBIaivRlk+u9Rba3X22IUi
         +1JYla8TIYVwHpS6pWoGh+7tZVnf+xpntbb3HfJebVCRuQWWg2RNEjhERIt7hfeWA2Ub
         yAAGgWIt20c6TTN4O4tu19sIkdUr08oV3m2veIT2Mj93Lli4/JZVEkGIShOFjxvlibua
         MdMw==
X-Gm-Message-State: APjAAAUACf2Yid+7xsiUeEZCZxbliU7mrRn/sVt5oCiHWooRYT0avMOa
        uGPJZYDekPdfK5Vb8aMgTvXAznMyZcUtmt61eg==
X-Google-Smtp-Source: APXvYqxQYc75pDaIKD0pyLcelJ+CWxV3o83zyl5WSERc2XeOnB/GkP9Qev7d+fOEJSmnFRqv4VtLsShSR42w/P0wC5Q=
X-Received: by 2002:a5d:8195:: with SMTP id u21mr28199395ion.260.1561992668660;
 Mon, 01 Jul 2019 07:51:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190701121720.18009-1-y.karadz@gmail.com> <20190701121720.18009-3-y.karadz@gmail.com>
In-Reply-To: <20190701121720.18009-3-y.karadz@gmail.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Mon, 1 Jul 2019 17:50:57 +0300
Message-ID: <CAE0o1NsAD7Z2KgsVqsGAyAQzA38d4iE3X=UXt-qM1EZKiXdmqw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] kernel-shark: Add support for drawing text
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Jul 1, 2019 at 3:42 PM Yordan Karadzhov (VMware)
<y.karadz@gmail.com> wrote:
>
> OpenGL doesn't provide support for text rendering. Here we add capability
> of printing text to the OpenGL scene by using the single-file public
> domain library "stb_truetype":
> https://github.com/nothings/stb/blob/master/stb_truetype.h
>
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark/src/libkshark-plot.c |  153 +-
>  kernel-shark/src/libkshark-plot.h |   35 +
>  kernel-shark/src/stb_truetype.h   | 4882 +++++++++++++++++++++++++++++
>  3 files changed, 5067 insertions(+), 3 deletions(-)
>  create mode 100644 kernel-shark/src/stb_truetype.h
>
> diff --git a/kernel-shark/src/libkshark-plot.c b/kernel-shark/src/libkshark-plot.c

[...]

> +void ksplot_print_text(const struct ksplot_font *font,
> +                      const struct ksplot_color *col,
> +                      float x, float y,
> +                      const char *text)
> +{
> +       glEnable(GL_TEXTURE_2D);
> +       glColor3ub(col->red, col->green, col->blue); // Text color
> +       glBindTexture(GL_TEXTURE_2D, font->texture_id);
> +       glBegin(GL_QUADS);
> +       while (*text) {
> +               if (*text >= KS_SPACE_CHAR && *text <= KS_TILDA_CHAR) {
> +                       stbtt_aligned_quad quad;
> +                       stbtt_GetBakedQuad(font->cdata,
> +                                          KS_FONT_BITMAP_SIZE,
> +                                          KS_FONT_BITMAP_SIZE,
> +                                          *text - KS_SPACE_CHAR,
> +                                          &x, &y,
> +                                          &quad,
> +                                          1);
> +
> +                       glTexCoord2f(quad.s0, quad.t1);
> +                       glVertex2f(quad.x0, quad.y1);
> +
> +                       glTexCoord2f(quad.s1, quad.t1);
> +                       glVertex2f(quad.x1, quad.y1);
> +
> +                       glTexCoord2f(quad.s1, quad.t0);
> +                       glVertex2f(quad.x1, quad.y0);
> +
> +                       glTexCoord2f(quad.s0, quad.t0);
> +                       glVertex2f(quad.x0, quad.y0);
> +               }
> +
> +               ++text;
> +       }

Nit: Can we have the above branch inverted to make the indentation
less deep? Maybe something like:

for (; *text; text++) {
        if (*text < KS_SPACE_CHAR || *text > KS_TILDA_CHAR)
                continue;

        stbtt_aligned_quad quad;
        stbtt_GetBakedQuad(font->cdata,
                           KS_FONT_BITMAP_SIZE,
                           KS_FONT_BITMAP_SIZE,
                           *text - KS_SPACE_CHAR,
                           &x, &y,
                           &quad,
                           1);

        glTexCoord2f(quad.s0, quad.t1);
        glVertex2f(quad.x0, quad.y1);

        glTexCoord2f(quad.s1, quad.t1);
        glVertex2f(quad.x1, quad.y1);

        glTexCoord2f(quad.s1, quad.t0);
        glVertex2f(quad.x1, quad.y0);

        glTexCoord2f(quad.s0, quad.t0);
        glVertex2f(quad.x0, quad.y0);
}

> +
> +       glDisable(GL_TEXTURE_2D);
> +       glEnd();
> +}
