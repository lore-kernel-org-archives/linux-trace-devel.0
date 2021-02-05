Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3A8C433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Feb 2021 10:58:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 966AF64F9C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Feb 2021 10:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhBEK6I (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Feb 2021 05:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbhBEKzr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Feb 2021 05:55:47 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AAAC06178C
        for <linux-trace-devel@vger.kernel.org>; Fri,  5 Feb 2021 02:50:01 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id d2so3556562pjs.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Feb 2021 02:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vnTOMmAa/EbMI4Yd2WJ+7t7GPiFrW5Y+6eA7S0uT6BE=;
        b=GLflNlUsE/z8SDK8KcgAXoTf540MEri8+KyWc6GGGMpMMJxz78KsMXDz4/n2IKzMH9
         uAes0rz2mBZqyqpwFceY5f1SLJ3qDMmaPUFLPptjRRuAEU5O/m3OmFcbfpl2xUvirFpW
         AJxfVEmxBRje2gEvQWeDP8TBa1l0Dl/1CGZ4Byqt8uMhw3nOfN9uo9oIghkd0REtLt3t
         GPr1pe+dAacBbkigt/MoJDL2AkyxuloyZnNHheK1fB26k+TSbgiv4T/KOzL+h/Wh/FeT
         AGKqAUDRyX0o7/bGA32HcW1vOovrumsJulcO2qvcM1fp/279wtymBric8rW7gFvQJMpz
         JJww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vnTOMmAa/EbMI4Yd2WJ+7t7GPiFrW5Y+6eA7S0uT6BE=;
        b=XJmXXG0TBj6Pfw8okujfFyeympC3enAR5v0waexxNHLZBaVpyhQByqbZrA5moXjH7r
         IDiKNi6ePAE52NmML6XdlEutbtyj3vDLOW+BUuaEIDpmvTmIUcibMCbWEKOmBlLr1tgD
         reHR3QgRzDibKZ+6E3I3WFjA+lN8NbXtvaWzcI8mOxQ0pzFH33vZXbsRTzINJcIuFK6O
         YzfkKy61lAIV7OLdzFASvEPpnU7uc7HLvtWAOR6KDRBsuRXRLbAuXTdcYcoP+ViR2hFH
         +qu6MaX8iKAmb4nn5tBnZeH147aj/lmbx0Bq1Sjb1n4Kgr3ySwynIymzF2EjjnVWmUJW
         0PNQ==
X-Gm-Message-State: AOAM533BJPAkJHWFEXUGCtyTEQoKVcRzGsstHHBnh5b+dF8aVPGKVysT
        cj79/VX0WHp4niipZytYN8XkV8kqx+ddZ2zB9k0=
X-Google-Smtp-Source: ABdhPJwzC6eN63Sy5VMC0NwtMSdkE0ralx8/iDbO8t66C2NdOdEdCiP/0c1YIhwElXTz0CTSFlv+5kQwBCR0OY/77FA=
X-Received: by 2002:a17:90a:cc03:: with SMTP id b3mr3700760pju.2.1612522201210;
 Fri, 05 Feb 2021 02:50:01 -0800 (PST)
MIME-Version: 1.0
References: <20210201172358.175407-1-y.karadz@gmail.com> <20210201172358.175407-16-y.karadz@gmail.com>
In-Reply-To: <20210201172358.175407-16-y.karadz@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 5 Feb 2021 12:49:44 +0200
Message-ID: <CAPpZLN70NLutFfwe8ftLk9T8bMAG-OsUaYuOXJA50n8eVC9kzQ@mail.gmail.com>
Subject: Re: [PATCH 15/24] kernel-shark: Update KsDualMarker and KsGLWidget
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Feb 1, 2021 at 7:26 PM Yordan Karadzhov (VMware)
<y.karadz@gmail.com> wrote:
>
> The compilation of KsDualMarker.cpp and KsGLWidget.cpp is re-enabled
> and all functionalities are made compatible with the new version of
> the C API of libkshark (KernelShark 2.0). The two source files are
> updated in a single patch because of their interdependence.
>
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/CMakeLists.txt   |   8 +-
>  src/KsDualMarker.cpp |  23 +-
>  src/KsDualMarker.hpp |  16 +-
>  src/KsGLWidget.cpp   | 718 +++++++++++++++++++++++++++++--------------
>  src/KsGLWidget.hpp   | 187 ++++++++---
>  5 files changed, 651 insertions(+), 301 deletions(-)
>

[...]

>  /** Reimplemented function used to set up all required OpenGL resources. */
>  void KsGLWidget::initializeGL()
>  {
> +       const char *family = KS_FONT, *name = "aaa";//KS_FONT;

The name of the font should not be hardcoded.

> +       char *font_file = ksplot_find_font_file(family, name);
> +       if (!font_file) {
> +               QErrorMessage *em = new QErrorMessage(this);
> +               QString text("Unable to find ");
> +               text += KS_FONT;
> +               text += " font.";
> +
> +               qCritical().noquote() << "ERROR:" << text;
> +               em->showMessage(text);
> +
> +               return;
> +       }
> +

[...]


--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
