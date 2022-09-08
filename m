Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F31C38145
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Sep 2022 22:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiIHWQ3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Sep 2022 18:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiIHWQ2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Sep 2022 18:16:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD5AE9144
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Sep 2022 15:16:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53803B82293
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Sep 2022 22:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8B21C433D6;
        Thu,  8 Sep 2022 22:16:24 +0000 (UTC)
Date:   Thu, 8 Sep 2022 18:16:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: Fixing linking to C++ code
Message-ID: <20220908181623.7f2385fe@rorschach.local.home>
In-Reply-To: <20220815031551.775444-1-joel@joelfernandes.org>
References: <20220815031551.775444-1-joel@joelfernandes.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, 14 Aug 2022 23:15:51 -0400
"Joel Fernandes (Google)" <joel@joelfernandes.org> wrote:

> Linking in C++ compilers (including g++) causes references to be created
> with their arguments. Due to this, trace library headers included into
> C++ code base will cause their objects to built with symbols with
> arguments. Apparently this is to support operator overloading in C++.
> 
> This causes linker errors. For example, here's what I get when I try to
> link libtraceevent with a main.o built from a C++ main.cc source file.
> 
>  main.cc:(.text+0x90):
> 	undefined reference to `trace_seq_init(trace_seq*)'
> 	undefined reference to `trace_seq_do_printf(trace_seq*)'
> 	undefined reference to `tep_event_fields(tep_event*)'
> 
> The standard fix for this is to wrap the C project's header in
> extern "C".
> 
> With this patch, I am able to link libtraceevent into a C++
> code base.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---

Applied. Thanks Joel!

-- Steve
