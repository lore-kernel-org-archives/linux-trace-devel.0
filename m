Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF87C54EE9
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Sep 2022 22:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiIHWQC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Sep 2022 18:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiIHWQB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Sep 2022 18:16:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A05DE3D63
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Sep 2022 15:15:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D5DBB82293
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Sep 2022 22:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61B8DC433C1;
        Thu,  8 Sep 2022 22:15:54 +0000 (UTC)
Date:   Thu, 8 Sep 2022 18:15:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "John 'Warthog9' Hawley (VMware)" <warthog9@eaglescrag.net>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: Makefile - set LIBS as conditional
 assignment
Message-ID: <20220908181553.59ddbf4d@rorschach.local.home>
In-Reply-To: <20220810235535.12887-1-warthog9@eaglescrag.net>
References: <20220810235535.12887-1-warthog9@eaglescrag.net>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 10 Aug 2022 16:55:35 -0700
"John 'Warthog9' Hawley (VMware)" <warthog9@eaglescrag.net> wrote:

> Need a way to override LIBS during certain compile operations (read:
> clang seemingly), so adjusting this so that LIBS can be defined and
> allow for overriding with specific intent to support package builds.
> 
> Signed-off-by: John 'Warthog9' Hawley (VMware) <warthog9@eaglescrag.net>


Applied. Thanks John!

-- Steve
