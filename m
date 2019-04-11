Return-Path: <SRS0=mCQn=SN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3E30C10F14
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 14:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 838CA217F4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 14:18:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="1uvsFwe6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfDKOSX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 10:18:23 -0400
Received: from conssluserg-05.nifty.com ([210.131.2.90]:58180 "EHLO
        conssluserg-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfDKOSX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 10:18:23 -0400
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169]) (authenticated)
        by conssluserg-05.nifty.com with ESMTP id x3BEICxk008898;
        Thu, 11 Apr 2019 23:18:13 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-05.nifty.com x3BEICxk008898
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1554992293;
        bh=9j8rMRfKUD0m6ORx02radXAU2lTG0PkvfcBaxQNYh4A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1uvsFwe6q2Aj5HIETUCyCkicnVMn+3QzfNddspcbIdx/HBSQZ1qvgEcAv/oN7Pi2n
         HDBhBT6+Y1Or+KHPxej8H2y7nyIHRO9lKkaBbR3vkFCVzgR//Fs3zmbWvcbjQeoocn
         6AKQFpDf+/d82O0rm9FV6F3bf2nuTdN9f7frOOBi+TMlCh6ZreQc+1BG10OaaK6TTz
         uGCi+wNDmMoBV5BUm+lyT/cxaCGQUYsD91HfEJNk82gS5mnHxR8vv5Mux5lwtY908g
         dcBzDoR+wSKcTs2ho5CLd47MzhkR5r9Gfzt+K5kLYC7pke2qLxbrgAZMbyQiKr7Wld
         pECCchic3kf0Q==
X-Nifty-SrcIP: [209.85.221.169]
Received: by mail-vk1-f169.google.com with SMTP id x194so1412338vke.0;
        Thu, 11 Apr 2019 07:18:13 -0700 (PDT)
X-Gm-Message-State: APjAAAVvCMKjV4nn/tawAGsI05zMiAduKJQNisIukPVlIWTv5jd22WVN
        oAgpzPhDR6IUgcuLB5m/VVBHRYBw/vM4euyzggc=
X-Google-Smtp-Source: APXvYqzqY1gf4npFaR6OqJLJ/o7hushnL2FxG70GjHmNRdZKF5iaJqlnVk4FEi7rwIkvC1TSCgiGIe9XU5GnnUa6C8Y=
X-Received: by 2002:a1f:793:: with SMTP id 141mr15380058vkh.31.1554992291951;
 Thu, 11 Apr 2019 07:18:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190408212855.233198-1-joel@joelfernandes.org> <20190408212855.233198-2-joel@joelfernandes.org>
In-Reply-To: <20190408212855.233198-2-joel@joelfernandes.org>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Thu, 11 Apr 2019 23:17:35 +0900
X-Gmail-Original-Message-ID: <CAK7LNATtZv9bgRn8g98=CGPL30YgRx+WVL6ihZBOgD_Vmerhvw@mail.gmail.com>
Message-ID: <CAK7LNATtZv9bgRn8g98=CGPL30YgRx+WVL6ihZBOgD_Vmerhvw@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] init/config: Do not select BUILD_BIN2C for IKCONFIG
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Apr 9, 2019 at 6:38 AM Joel Fernandes (Google)
<joel@joelfernandes.org> wrote:
>
> Since commit 13610aa908dc ("kernel/configs: use .incbin directive to
> embed config_data.gz"), IKCONFIG no longer uses BUILD_BIN2C so prevent
> it from being selected in Kconfig.
>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>


This patch is independent of 1/2,
and trivial enough.

Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>


> ---
>  init/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/init/Kconfig b/init/Kconfig
> index ea75bfbf7dfa..ffcb2f90543f 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -562,7 +562,6 @@ config BUILD_BIN2C
>
>  config IKCONFIG
>         tristate "Kernel .config support"
> -       select BUILD_BIN2C
>         ---help---
>           This option enables the complete Linux kernel ".config" file
>           contents to be saved in the kernel. It provides documentation
> --
> 2.21.0.392.gf8f6787159e-goog
>


-- 
Best Regards
Masahiro Yamada
