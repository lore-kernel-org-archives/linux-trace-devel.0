Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A45C5C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Feb 2022 17:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241090AbiBDRin (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 12:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiBDRim (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 12:38:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E602C061714
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Feb 2022 09:38:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DFAAFCE23D2
        for <linux-trace-devel@vger.kernel.org>; Fri,  4 Feb 2022 17:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF446C004E1;
        Fri,  4 Feb 2022 17:38:38 +0000 (UTC)
Date:   Fri, 4 Feb 2022 12:38:37 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: fix cleaning of sqlhist.txt.html
Message-ID: <20220204123837.341cb591@gandalf.local.home>
In-Reply-To: <20220124111031.84108-1-krzysztof.kozlowski@canonical.com>
References: <20220124111031.84108-1-krzysztof.kozlowski@canonical.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 24 Jan 2022 12:10:31 +0100
Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com> wrote:

> The man-1 HTML pages also has to be cleaned up.

Applied, thanks Krzysztof!

-- Steve

> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  Documentation/Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/Makefile b/Documentation/Makefile
> index 92a67aa1760c..afcb6a53ccd0 100644
> --- a/Documentation/Makefile
> +++ b/Documentation/Makefile
> @@ -197,6 +197,7 @@ endif
>  CLEAN_FILES =					\
>  	$(MAN_XML) $(addsuffix +,$(MAN_XML))	\
>  	$(MAN_HTML) $(addsuffix +,$(MAN_HTML))	\
> +	$(MAN1_HTML) $(addsuffix +,$(MAN1_HTML))	\
>  	$(filter-out $(MAN1_TEXT),$(wildcard *.1)) \
>  	$(DOC_MAN3) *.3 *.m
>  

