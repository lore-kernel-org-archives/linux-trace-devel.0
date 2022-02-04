Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A33FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Feb 2022 02:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356637AbiBDClL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Feb 2022 21:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbiBDClK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Feb 2022 21:41:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDADC061714
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Feb 2022 18:41:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F831B83569
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Feb 2022 02:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB6DC340E8;
        Fri,  4 Feb 2022 02:41:07 +0000 (UTC)
Date:   Thu, 3 Feb 2022 21:41:06 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] libtracefs: clean also docs by default
Message-ID: <20220203214106.458cb2c4@gandalf.local.home>
In-Reply-To: <20220124105252.64897-1-krzysztof.kozlowski@canonical.com>
References: <20220124105252.64897-1-krzysztof.kozlowski@canonical.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 24 Jan 2022 11:52:51 +0100
Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com> wrote:

> Logical is that `make clean` cleans everything done from build, not only
> parts.  Leaving the documentation unclean requires additional step
> when building for example Debian packages:
> 
>     $ dpkg-buildpackage -us -uc
>     ...
>     dpkg-source: info: local changes detected, the modified files are:

The reason we did this is because docs are not made by default.

(Yes you can say the same about utest, src and samples but those are all
code).

I've always kept the doc build (and cleanup) separate from the normal build.

Is it normal to remove the docs in other projects?

-- Steve



> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Makefile b/Makefile
> index 544684c1c37c..4650d15d64e9 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -375,6 +375,7 @@ samples: libtracefs.a force
>  	$(Q)$(call descend,$(src)/samples,all)
>  
>  clean:
> +	$(Q)$(call descend_clean,Documentation)
>  	$(Q)$(call descend_clean,utest)
>  	$(Q)$(call descend_clean,src)
>  	$(Q)$(call descend_clean,samples)

