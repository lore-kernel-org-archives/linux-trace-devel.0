Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DATE_IN_PAST_06_12,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 448A1C282E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 132D9222CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:26:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mvVOakJL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfDSS04 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:26:56 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:38012 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfDSS0z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 14:26:55 -0400
Received: by mail-vs1-f65.google.com with SMTP id s2so3254419vsi.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Apr 2019 11:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AVQij/gxmsGz8fqLZw159lOAbAYTNfP7fRcu4NDV1E4=;
        b=mvVOakJLFs817AbDoKDRi2NIHV4djyxlhrKcoIn7x5NTYuuqhVXAbhlhZ7uO4xVOI9
         4H/TtM/lOZP/RKrJ49Hg5Xb0BEaATRenyeDFtQjyGGe/vDqmptM/ItJu5vcPISSG6bmn
         xtW63Tv5YsleQf76VlnNy7YHQBQVTMtooKWPyM4XKrjvS5suTsZvroJgO8+scd8/Aq7l
         BGzE2BNrHdV1BSkeDh0n4JLqadvM+pY2eVZp1qXX30FhTYbZ3FGzxMJpCrUiguMgMHVa
         GApx79wrAfZa9JXVJMqZPNp63KBl0uCioUMXeIpsvuVs1z3Tyc31i+0gS1r8TUzlzknc
         I0Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AVQij/gxmsGz8fqLZw159lOAbAYTNfP7fRcu4NDV1E4=;
        b=By3TRk2tGgdUElS/kxBixJ2PtynpAfYxf5Embo1KEgrSWPoZJ/RRXbTIqCOzEFcb3j
         W/bU6B8v+HfTJ3Pa1n/z+oAJtL8tEgilnSULPGNNYcLebheqnki4sMIVrmFvdMsgi6B8
         jZenI9AVxnTjFr5jsFH/ogLR63IG/W1wT/fhN62WK4Xw8/dXidSl68QxSibptUAwJw30
         N1+ob/ZexoDIDXcp+O8cCHeOClAV5pGLF/IlqAiGnDtgC0wOT5KXFVMMCM24bLgWfB7r
         AsCUsqd7lJZ0S4i0NsOENgaOO9GisnExR5zDvu+BtpFijc/jkOTq5d5tcG5FgfvJePsM
         L+xw==
X-Gm-Message-State: APjAAAWSKtWreKZpfyU5RIiSdfZm5lAq7OMw+dJ+ec2Epg4I4dSsGLJ9
        IFzl1rMkmHR56XlHD1yjOnukHWcW8nGdj0/YqzHylXNdOA==
X-Google-Smtp-Source: APXvYqzDR6ZJ3TUn3gGariyU1BYGTXRHt2mqrObVrDgAExhmT0wqVbBjiykbS9it8H9CBLZV6MiH28eKO3tb+3a+cEM=
X-Received: by 2002:a67:fb89:: with SMTP id n9mr1318434vsr.119.1555659808413;
 Fri, 19 Apr 2019 00:43:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190418152146.27232-1-ykaradzhov@vmware.com> <20190418152146.27232-5-ykaradzhov@vmware.com>
In-Reply-To: <20190418152146.27232-5-ykaradzhov@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Fri, 19 Apr 2019 10:43:17 +0300
Message-ID: <CAE0o1NvY=KHwDQXLB0YCPtUAc8UxzgKvsj4g89j1iv64zvfYKg@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] kernel-shark: Add logic for the plugins search path
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 18, 2019 at 6:22 PM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>
> If the application has been started from the source code directory, all
> build-in plugins will be loaded from kernel-shark/lib/
> If the application has been started from its installation location, all
> build-in plugins will be loaded from INSTALL_PREFIX/lib/kshark/plugins/
>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/build/deff.h.cmake         |  3 +++
>  kernel-shark/src/KsUtils.cpp            | 35 +++++++++++++++++--------
>  kernel-shark/src/KsUtils.hpp            |  1 +
>  kernel-shark/src/plugins/CMakeLists.txt |  2 +-
>  4 files changed, 29 insertions(+), 12 deletions(-)
>
> diff --git a/kernel-shark/build/deff.h.cmake b/kernel-shark/build/deff.h.cmake
> index 8041cfc..ba211f4 100644
> --- a/kernel-shark/build/deff.h.cmake
> +++ b/kernel-shark/build/deff.h.cmake
> @@ -14,6 +14,9 @@
>  /** KernelShark source code path. */
>  #cmakedefine KS_DIR "@KS_DIR@"
>
> +/** KernelShark installation prefix path. */
> +#cmakedefine _INSTALL_PREFIX "@_INSTALL_PREFIX@"
> +
>  /** Location of the trace-cmd executable. */
>  #cmakedefine TRACECMD_BIN_DIR "@TRACECMD_BIN_DIR@"
>
> diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
> index 6af0c66..b05c0dc 100644
> --- a/kernel-shark/src/KsUtils.cpp
> +++ b/kernel-shark/src/KsUtils.cpp
> @@ -423,13 +423,12 @@ void KsPluginManager::_parsePluginList()
>   */
>  void KsPluginManager::registerFromList(kshark_context *kshark_ctx)
>  {
> -       auto lamRegBuiltIn = [&kshark_ctx](const QString &plugin)
> +       auto lamRegBuiltIn = [&kshark_ctx, this](const QString &plugin)

Prefixing lambda function names with 'lam' is an interesting modern
form of Hungarian notation[1]. It's not useful for the reader or the
compiler and it doesn't make a great style. No need to change this
patch but having a clean up patch that does a bulk rename would be
nice.

Other than that the patch looks good to me and also for patches 2, 4, 5 and 6

Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>

Cheers,

-- Slavi

[1]https://en.wikipedia.org/wiki/Hungarian_notation
