Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974D0C0015E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 23:47:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjHIXrs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 19:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjHIXrs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 19:47:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B46F7
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 16:47:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD4EA647C6
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 23:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8619C433C8;
        Wed,  9 Aug 2023 23:47:46 +0000 (UTC)
Date:   Wed, 9 Aug 2023 19:47:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     bugzilla-daemon@kernel.org
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [Bug 217768] Build error
Message-ID: <20230809194745.5effe2aa@gandalf.local.home>
In-Reply-To: <20230809194602.23772701@gandalf.local.home>
References: <bug-217768-8243@https.bugzilla.kernel.org/>
        <bug-217768-8243-86af6q0Txp@https.bugzilla.kernel.org/>
        <20230809194602.23772701@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 9 Aug 2023 19:46:02 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Perhaps we need to make all __hidden functions have a prefix. Hmm, perhaps just add:
> 
>  "_tracecmd_" or "_tracefs_" to the front of it?
> 
> That is, for strstrip() in trace-cmd, rename it to: _tracecmd_strstrip()
> 
> and for libtracefs: _libtracefs_strstrip()

That should have been: _tracefs_strstrip()
