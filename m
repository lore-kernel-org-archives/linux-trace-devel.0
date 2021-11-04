Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A315C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EEE56124A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhKDVKw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 17:10:52 -0400
Received: from linux.microsoft.com ([13.77.154.182]:51804 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbhKDVKw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 17:10:52 -0400
Received: from kbox (unknown [24.17.193.74])
        by linux.microsoft.com (Postfix) with ESMTPSA id D86AF20B9CE9;
        Thu,  4 Nov 2021 14:08:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D86AF20B9CE9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636060094;
        bh=ne8MhrlcQR/uA1pB2cp2HZLqbytWwz//W+s1xO/MnD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZaVfc2k8oVDTq4WlXnyvrybjNshBHbCcmj+La5SktMDKcHaDXbVjbFaibxgjV36KO
         bo6jEY+Y74t4SJdxQwwgrB5O9Cb1juW/J9P98LRKjHFXzh598AD6bbJkKTPBDljunI
         JJM0wVynCw0VuF658B1GNTnsc08y2+863uOdrO6o=
Date:   Thu, 4 Nov 2021 14:08:09 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     rostedt@goodmis.org, mhiramat@kernel.org,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 10/10] user_events: Add documentation file
Message-ID: <20211104210809.GA2486@kbox>
References: <20211104170433.2206-1-beaub@linux.microsoft.com>
 <20211104170433.2206-11-beaub@linux.microsoft.com>
 <8735obrbao.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735obrbao.fsf@meer.lwn.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Nov 04, 2021 at 01:05:51PM -0600, Jonathan Corbet wrote:
> Beau Belgrave <beaub@linux.microsoft.com> writes:
> 
> > Add a documentation file about user_events with example code, etc.
> > explaining how it may be used.
> 
> Yay documentation!  Some nits for a slow moment...
> 
> > Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> > ---
> >  Documentation/trace/user_events.rst | 298 ++++++++++++++++++++++++++++
> >  1 file changed, 298 insertions(+)
> >  create mode 100644 Documentation/trace/user_events.rst
> 
> Actually, this isn't really a nit.  When you add a new RST file, you
> need to add it to the index.rst file too so that it gets pulled into the
> docs build.  Otherwise you'll get the warning you doubtless saw when you
> tried building the docs after adding this file...:)
> 

Thanks for the review, I'll fix these things up!

> > +Example Code
> > +------------
> 
> Examples are great, but they are best placed under samples/ (or tools/
> if they do something useful) where readers can build and run them.
> 

Ok, sounds good. Is it fine to include user mode samples in there? I
quickly checked and most appear to be modules. Maybe there is a better
place for user mode examples?

Thanks,
-Beau
