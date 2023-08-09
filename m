Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35739C0015E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 23:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjHIXqJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 19:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjHIXqI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 19:46:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8E8F7
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 16:46:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A87AE64418
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 23:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63ECC433C8;
        Wed,  9 Aug 2023 23:46:05 +0000 (UTC)
Date:   Wed, 9 Aug 2023 19:46:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     bugzilla-daemon@kernel.org
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [Bug 217768] Build error
Message-ID: <20230809194602.23772701@gandalf.local.home>
In-Reply-To: <bug-217768-8243-86af6q0Txp@https.bugzilla.kernel.org/>
References: <bug-217768-8243@https.bugzilla.kernel.org/>
        <bug-217768-8243-86af6q0Txp@https.bugzilla.kernel.org/>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 09 Aug 2023 11:54:15 +0000
bugzilla-daemon@kernel.org wrote:

https://bugzilla.kernel.org/show_bug.cgi?id=217768

--- Comment #1 from Douglas RAILLARD (douglas.raillard@arm.com) ---

> So since there is no way to get a visibility-based namespace in C that works
> for libs with more than one ELF file in it (i.e. static lib with more than one
> .o), the options are:

Hi Douglas,

Thanks for looking into this and debugging it. Yeah, I figured that
__hidden was going to bite me sooner or later. :-/


> 
>   1. Change the name of one of the definitions.
>   2. Move that function to a 3rd library and make the other 2 depend on it.
>   3. pre-link all the object files in libtracefs.a into a single .o
> 
> 
> This patch implements 3. for libtracefs and fixes static build of trace-cmd. A
> similar patch would be needed for libtraceevent and libtracecmd even though
> there is currently no symbol conflict (by chance):

Actually, I prefer #1. #2 is out of the question. But trace-cmd actually
depends on hidden functions being accessible during linking. That is, the
trace-cmd binary uses __hidden functions in libtracecmd. The __hidden()
just means that they should not be relied on.

Perhaps we need to make all __hidden functions have a prefix. Hmm, perhaps just add:

 "_tracecmd_" or "_tracefs_" to the front of it?

That is, for strstrip() in trace-cmd, rename it to: _tracecmd_strstrip()

and for libtracefs: _libtracefs_strstrip()

by convention, anything that starts with "tracecmd_" or "tracefs_" should
be exposed and considered API. We can have that anything with "_tracecmd_"
or "_tracefs_" is to be hidden and not part of the API.

-- Steve
