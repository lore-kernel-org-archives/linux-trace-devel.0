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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC7B4C0650E
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jul 2019 14:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9043020659
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Jul 2019 14:35:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qNhRRk1V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbfGAOfd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 10:35:33 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:42027 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfGAOfd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 10:35:33 -0400
Received: by mail-io1-f68.google.com with SMTP id u19so20779447ior.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Jul 2019 07:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PouRNO+vQJamLc22UPuGav7+GLASLTTu6Q6cDiW42Zo=;
        b=qNhRRk1Vx/spCTrKs5Cy+ot272C5Tk0DdXyDfSw0LlbYNfMMNP1Ho2NSJQOarqt3ZE
         WLQM6MmjO/qy+WadZjTRCyijRa1RfpEKZzVcS8qq9wPlaEKUcQhoqqSybgNhxDiI1SUQ
         SMY61tcRXoiH0LzgH3P9e2EGsvhqQXz6Khef5mNhsXW9eT19FjaheBzwQUMSTZ4JuokJ
         2cDj1WXxuASFbkZ+h7YYOdT2ivRZMaSc2lvDkAA4e7cVY4coVD3+8M6/dH0u91TQ0dcm
         BaD78r2+t1r2cDH4imspT7i83zUnuBwMaS7q+DLxQMFaeGlmEy0zF6ISZ4sQUxzyVv6Q
         rYpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PouRNO+vQJamLc22UPuGav7+GLASLTTu6Q6cDiW42Zo=;
        b=HctSuzK1xDZoy/J5lcfHlrcoqrENcOk+6laNNykq2DXuQd/KoE/44N6ViUtmejo1MD
         Clwr5U4foA3hcV92cPD/YJSnl9pmX2uz2RV53QNqaLYyRh2LM5gSlaM0Snm2/Q8fTpXb
         lN3kjYiuMb9PwYJZLCI3WsDq/ah3+2uhYQuyKy5U6typKvu8in+iXbbjHqvsiJzjna2q
         bSERwtnkq1fnE8Zu+DtYh7wCW3Ub1CU1l7llZum7NQ4ohBr5oUpIiLjlODqP7CjMocbL
         qijpWOeHmWrs8KVZh8hf5rGYbVJ87zHx6BdvsGdqtkaYOgRhth+fIFV08WcS8BoxUkqk
         qedQ==
X-Gm-Message-State: APjAAAXgEMsi9Cv9dnae4lcCpqxaAXcZax3nULp/Lg1qjez/RMYl2XXe
        tqkf9WkLo3cNetl2iuKXHb4h8uIIFwkknAUAE2Yx0YNo7Q==
X-Google-Smtp-Source: APXvYqz3MEYvr5Gkv6h9iwNIiHTJwe7H6pvbrlbb2zVU1VSjxfZAlGezWf0kIcV6xPHd/D8Egf3HW2HxY5H/gngtc8c=
X-Received: by 2002:a5d:8195:: with SMTP id u21mr28113569ion.260.1561991731859;
 Mon, 01 Jul 2019 07:35:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190701121720.18009-1-y.karadz@gmail.com> <20190701121720.18009-3-y.karadz@gmail.com>
In-Reply-To: <20190701121720.18009-3-y.karadz@gmail.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Mon, 1 Jul 2019 17:35:20 +0300
Message-ID: <CAE0o1Nvv4Snr3sTfuijmdS-i9Oyt_hKUXxnhKNVWo4WEm+h_KA@mail.gmail.com>
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
> index cdd0ef8..36982e3 100644
> --- a/kernel-shark/src/libkshark-plot.c
> +++ b/kernel-shark/src/libkshark-plot.c
> @@ -9,13 +9,21 @@
>    *  @brief   Basic tools for OpenGL plotting.
>    */

 [...]

>
>
> +bool ksplot_init_font(struct ksplot_font *font, float size, const char *file)
> +{
> +       unsigned char bitmap[KS_FONT_BITMAP_SIZE * KS_FONT_BITMAP_SIZE];
> +       ssize_t buff_size, ret;
> +       unsigned char *buffer;
> +       stbtt_fontinfo info;
> +       FILE *font_file;
> +
> +       font_file = fopen(file, "rb");
> +       if (!font_file) {
> +               fprintf(stderr, "Failed to open font file!\n");
> +               return false;
> +       }
> +
> +       /* Get the size of the file. */
> +       fseek(font_file, 0, SEEK_END);
> +       buff_size = ftell(font_file);
> +       fseek(font_file, 0, SEEK_SET);
> +
> +       buffer = malloc(buff_size);
> +       if (!buffer) {

font_file doesn't get fclose()d in this case.

>
> +               fprintf(stderr, "Failed to allocat memory for font!\n");
> +               goto fail;
> +       }
> +
> +       ret = fread(buffer, buff_size, 1, font_file);
> +       fclose(font_file);
> +
> +       if (ret == 0) {
> +               fprintf(stderr, "Failed to read from font file!\n");
> +               goto fail;
> +       }
> +
> +       if (!stbtt_InitFont(&info, buffer, 0)) {
> +               fprintf(stderr, "Failed to init font!\n");
> +               goto fail;
> +       }
> +
> +       ret = stbtt_BakeFontBitmap(buffer,
> +                                  0,
> +                                  size,
> +                                  bitmap,
> +                                  KS_FONT_BITMAP_SIZE,
> +                                  KS_FONT_BITMAP_SIZE,
> +                                  KS_SPACE_CHAR,
> +                                  KS_N_CHAR,
> +                                  font->cdata);
> +
> +       if (ret <= 0) {
> +               fprintf(stderr, "Failed to bake font bitmap!\n");
> +               goto fail;
> +       }
> +
> +       free(buffer);
> +
> +       glGenTextures(1, &font->texture_id);
> +       glBindTexture(GL_TEXTURE_2D, font->texture_id);
> +
> +       glTexImage2D(GL_TEXTURE_2D,
> +                    0,
> +                    GL_ALPHA,
> +                    KS_FONT_BITMAP_SIZE,
> +                    KS_FONT_BITMAP_SIZE,
> +                    0,
> +                    GL_ALPHA,
> +                    GL_UNSIGNED_BYTE,
> +                    bitmap);
> +
> +       glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
> +       glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
> +       glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
> +       glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
> +
> +       return true;
> +
> + fail:
> +       free(buffer);
> +       return false;
> +}

[...]

> diff --git a/kernel-shark/src/libkshark-plot.h b/kernel-shark/src/libkshark-plot.h
> index 9a4dbc0..617dca0 100644
> --- a/kernel-shark/src/libkshark-plot.h
> +++ b/kernel-shark/src/libkshark-plot.h
> @@ -12,6 +12,16 @@
>  #ifndef _LIB_KSHARK_PLOT_H
>  #define _LIB_KSHARK_PLOT_H
>
> +// OpenGL
> +#include <GL/freeglut.h>

Freeglut is used only in ksplot_make_scene() and is not a necessary
dependency for programs that use Qt for window and OpenGL context
management. Can we drop freeglut as a dependency for libkshark-plot
and move ksplot_make_scene() to where its only use is (in
examples/dataplot.cpp)?

The rest of the patch looks great.

Thank you,

-- Slavi
