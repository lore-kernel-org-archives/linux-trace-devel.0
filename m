Return-Path: <SRS0=qKFV=22=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B4BFC33C8C
	for <linux-trace-devel@archiver.kernel.org>; Sun,  5 Jan 2020 13:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6296B20866
	for <linux-trace-devel@archiver.kernel.org>; Sun,  5 Jan 2020 13:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1578230302;
	bh=uhFqVZ7n7Rc+7P7Mc3LqB9MCnQvkQwYs53kehUomJsI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=ehCBPbocKk+JxOwQD3GbBhOGyFnjnZGVnOW0DLiKgKBc9i095W0RmfykdLCKz7sBp
	 gzXvJUweKNlOMl+6A5A1hN4HtbVTdwKixMqcmUlyP/tiRadLhJ0+ARkShOLQB5jO6J
	 h/VrYVRpQbW9lvg7NP7Q6LUsOzg87dJnooyEy5vk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgAENSV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 5 Jan 2020 08:18:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:38240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbgAENSV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 5 Jan 2020 08:18:21 -0500
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5AAF207FD;
        Sun,  5 Jan 2020 13:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578230300;
        bh=uhFqVZ7n7Rc+7P7Mc3LqB9MCnQvkQwYs53kehUomJsI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xG0sQE5j/aFhsFpcN+gCjWHFRhVOn2PDU5EBsi6f6QfTGgt/KmVHGhfIYQdYv0X6B
         JAL0YXEqyVoPel1D/veDBBjjIKFMVIKxJkwqaalFh44LNdl1088hDlzgioc3GgV3XI
         REj8VI0fzZYI3UU6k0NotVPOdyT+XVRFOj1gHBFQ=
Date:   Sun, 5 Jan 2020 22:18:14 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] tools lib traceevent: How to do library versioning being
 in the Linux kernel source?
Message-Id: <20200105221814.ed6a53012ec9945296029add@kernel.org>
In-Reply-To: <20200103181242.4802727e@gandalf.local.home>
References: <20200102122004.216c85da@gandalf.local.home>
        <20200103211743.b474f74d0a039624d37989bc@kernel.org>
        <20200103181242.4802727e@gandalf.local.home>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 3 Jan 2020 18:12:42 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 3 Jan 2020 21:17:43 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > +1. It sounds reasonable to move the main part of libtraceevent out
> > of kernel tree. BTW, the plugins seems depending on the kernel. Maybe
> > we can provide it under
> > /lib/modules/<kversion>/shared/libtraceevent/plugins/ ? :)
> 
> They really shouldn't be. They should be able to be used between
> different versions of the kernel. Which plugins do you see an issue
> with?

I meant tools/lib/traceevent/plugins.
It seems that those plugins provide equivarent codes of some macros
or values in event formats. In that case, when a new kernel modifies
the event definitions, I think some of those needs to be updated too.
Or, would those events be considered as a stable ABI?

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
