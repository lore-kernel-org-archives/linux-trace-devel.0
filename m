Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8404C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Feb 2022 02:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353781AbiBDCoN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Feb 2022 21:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbiBDCoN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Feb 2022 21:44:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD00DC061714
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Feb 2022 18:44:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A83F5B83625
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Feb 2022 02:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22FACC340E8;
        Fri,  4 Feb 2022 02:44:10 +0000 (UTC)
Date:   Thu, 3 Feb 2022 21:44:08 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] libtracefs: fix utest linking path
Message-ID: <20220203214408.62da9a6f@gandalf.local.home>
In-Reply-To: <20220124105252.64897-2-krzysztof.kozlowski@canonical.com>
References: <20220124105252.64897-1-krzysztof.kozlowski@canonical.com>
        <20220124105252.64897-2-krzysztof.kozlowski@canonical.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 24 Jan 2022 11:52:52 +0100
Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com> wrote:


Hi Krzysztof,

When submitting a patch, can you have the first word start with a capital
letter:

   "[PATCH 2/2] libtracefs: Fix utest linking path"


> Build libraries are now in lib/.  This fixes test error:
> 
>     /usr/bin/ld: cannot find ..libtracefs/lib/tracefs/libtracefs.a: No such file or directory
> 
> Fixes: fe21539dc846 ("libtracefs: Build in the same directories as the source")
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  utest/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/utest/Makefile b/utest/Makefile
> index d168b01a328c..74bf7e60b91d 100644
> --- a/utest/Makefile
> +++ b/utest/Makefile
> @@ -12,7 +12,7 @@ OBJS += tracefs-utest.o
>  
>  LIBS += -lcunit				\
>  	-ldl				\
> -	$(obj)/lib/tracefs/libtracefs.a
> +	$(obj)/lib/libtracefs.a

I was thinking how this failed for me. But I now see that my make clean
never removed the old directory and library.

Thanks for this! I'll apply it.

-- Steve


>  
>  OBJS := $(OBJS:%.o=$(bdir)/%.o)
>  DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)

