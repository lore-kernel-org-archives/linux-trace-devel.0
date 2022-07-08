Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94965C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Jul 2022 18:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239541AbiGHSX1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239359AbiGHSXL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Jul 2022 14:23:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9082187341
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Jul 2022 11:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F10062474
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Jul 2022 18:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB4BC341C6;
        Fri,  8 Jul 2022 18:22:50 +0000 (UTC)
Date:   Fri, 8 Jul 2022 14:22:48 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: avoid pointless extra DEP stage
Message-ID: <20220708142248.19af0aa9@gandalf.local.home>
In-Reply-To: <20220620150316.21022-1-jengelh@inai.de>
References: <20220620150316.21022-1-jengelh@inai.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 20 Jun 2022 17:03:16 +0200
Jan Engelhardt <jengelh@inai.de> wrote:

>  clean:
> -	$(Q)$(call do_clean,$(OBJS) .*.d)
> +	$(Q)$(call do_clean,$(OBJS) *.d)
>  
> -dep_includes := $(wildcard $(DEPS))
> -
> -ifneq ($(dep_includes),)
> -  include $(dep_includes)
> -endif
> +-include *.d
>  

After this change, the .d files are visible. Is there a way to keep them
hidden? That is, keep the . in front?

-- Steve
