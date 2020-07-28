Return-Path: <SRS0=DbCI=BH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92A5C433E3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Jul 2020 13:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5699206D7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Jul 2020 13:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729984AbgG1NXY convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Jul 2020 09:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729433AbgG1NXY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Jul 2020 09:23:24 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B122E206D7;
        Tue, 28 Jul 2020 13:23:23 +0000 (UTC)
Date:   Tue, 28 Jul 2020 09:23:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/5] KernelShark: Fix compilation issues on  Fedora 32
Message-ID: <20200728092322.346d827c@oasis.local.home>
In-Reply-To: <20200727071823.169962-3-tz.stoyanov@gmail.com>
References: <20200727071823.169962-1-tz.stoyanov@gmail.com>
        <20200727071823.169962-3-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 27 Jul 2020 10:18:20 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> 
> Included <string.h> to fix this compilation error:

s/<string.h>/<string>

>    "error: ‘string’ in namespace ‘std’ does not name a type"
> Converted fontHeight and stringWidth to inline to fix these
> compilation errors:
>    "multiple definition of `fontHeight';"
>    "multiple definition of `stringWidth';"
> 

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

-- Steve

> Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
> ---
>  src/KsPlotTools.cpp | 1 +
>  src/KsPlotTools.hpp | 1 +
>  src/KsUtils.hpp     | 4 ++--
>  3 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
> index 17db451..7dcd4f2 100644
> --- a/src/KsPlotTools.cpp
> +++ b/src/KsPlotTools.cpp
> @@ -12,6 +12,7 @@
>  // C
>  #include <math.h>
>  #include <cstring>
> +#include <string>
>  
>  // C++
>  #include <algorithm>
> diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
> index 75fb4da..c66fea3 100644
> --- a/src/KsPlotTools.hpp
> +++ b/src/KsPlotTools.hpp
> @@ -14,6 +14,7 @@
>  
>  // C
>  #include <math.h>
> +#include <string>
>  
>  // C++
>  #include <limits>
> diff --git a/src/KsUtils.hpp b/src/KsUtils.hpp
> index cfb45f4..5857099 100644
> --- a/src/KsUtils.hpp
> +++ b/src/KsUtils.hpp
> @@ -36,7 +36,7 @@
>  
>  //! @cond Doxygen_Suppress
>  
> -auto fontHeight = []()
> +inline auto fontHeight = []()
>  {
>  	QFont font;
>  	QFontMetrics fm(font);
> @@ -44,7 +44,7 @@ auto fontHeight = []()
>  	return fm.height();
>  };
>  
> -auto stringWidth = [](QString s)
> +inline auto stringWidth = [](QString s)
>  {
>  	QFont font;
>  	QFontMetrics fm(font);

