Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77B7AC6FA8B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Sep 2022 23:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiIHXeV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Sep 2022 19:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbiIHXeB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Sep 2022 19:34:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A600C10F8EB
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Sep 2022 16:31:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B192F61DBB
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Sep 2022 23:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5760C43470;
        Thu,  8 Sep 2022 23:31:48 +0000 (UTC)
Date:   Thu, 8 Sep 2022 19:32:30 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexandre Vicenzi <alexandre.vicenzi@suse.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/3] libtracefs: Add tracefs_tracer_available helper
Message-ID: <20220908193230.277e2189@gandalf.local.home>
In-Reply-To: <20220826142420.29911-1-alexandre.vicenzi@suse.com>
References: <20220826142420.29911-1-alexandre.vicenzi@suse.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 26 Aug 2022 16:24:18 +0200
Alexandre Vicenzi <alexandre.vicenzi@suse.com> wrote:

> Add tracefs_tracer_available helper function to check if a giver tracer is available.
> 
> Signed-off-by: Alexandre Vicenzi <alexandre.vicenzi@suse.com>
> ---
>  

Your three patches were applied (and I picked the last one with your SOB).

Thanks Alexandre!

-- Steve
