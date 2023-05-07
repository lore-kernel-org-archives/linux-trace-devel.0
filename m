Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E6A4C77B75
	for <linux-trace-devel@archiver.kernel.org>; Sun,  7 May 2023 01:51:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjEGBva (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 6 May 2023 21:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjEGBv3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 6 May 2023 21:51:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD7316344
        for <linux-trace-devel@vger.kernel.org>; Sat,  6 May 2023 18:51:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8D2560BEE
        for <linux-trace-devel@vger.kernel.org>; Sun,  7 May 2023 01:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C443C433D2;
        Sun,  7 May 2023 01:51:26 +0000 (UTC)
Date:   Sat, 6 May 2023 21:51:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH trace-cmd v2 0/3] trace-cmd filtering
Message-ID: <20230506215124.3330400d@rorschach.local.home>
In-Reply-To: <87ild584w9.fsf@suse.de>
References: <20230330185211.5604-1-krisman@suse.de>
        <87ild584w9.fsf@suse.de>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, 06 May 2023 18:35:34 -0400
Gabriel Krisman Bertazi <krisman@suse.de> wrote:

> Gabriel Krisman Bertazi <krisman@suse.de> writes:
> 
> > Hi Steve,  
> 
> I wanted to ping you regarding this patchset.  Do you intend to take
> this as-is?
> 

Apologies, I've been mostly focused on the kernel the last few weeks,
but as I'm giving a talk on the tracing libraries on Thursday, I'll be
focusing on them now ;-)

   https://ossna2023.sched.com/event/1K58e

So I'll reply in a few days.

-- Steve
