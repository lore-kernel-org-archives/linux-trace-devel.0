Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:42116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752995AbdLMPxV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Dec 2017 10:53:21 -0500
Date: Wed, 13 Dec 2017 10:53:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vladislav Valtchev <vladislav.valtchev@gmail.com>
Cc: y.karadz@gmail.com, linux-trace-devel@vger.kernel.org
Subject: Re: [RFC PATCH v3 0/9] trace-cmd: restructure of the source tree
 [incomplete]
Message-ID: <20171213105318.5d8b3056@gandalf.local.home>
In-Reply-To: <1513173368.2565.64.camel@gmail.com>
References: <20171212162534.31144-1-vladislav.valtchev@gmail.com>
        <20171212193004.05efce2e@gandalf.local.home>
        <1513173368.2565.64.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 13 Dec 2017 15:56:08 +0200
Vladislav Valtchev <vladislav.valtchev@gmail.com> wrote:

> On Tue, 2017-12-12 at 19:30 -0500, Steven Rostedt wrote:
> > Hi Vlad,
> > 
> > The patches look decent. I made a few comments, but I think you can
> > send then non RFC next time after incorporating what I suggested.
> >   
> 
> I'm so happy that you liked them!
> Sure, I can make the next iteration non-RFC. Just, I was planning to add
> also the last 3 patches for:
> 
> src/plugins
> src/trace-cmd/include
> src/trace-cmd
> 
> As part of the same series. The alternative is calling this series:
> 
> "trace-cmd: restructure of the source tree [part 1]".
> 
> and the next one "... [part 2]".
> 
> 
> Which do you think is better?

Do it in the next non-RFC patch set. I think you are starting to get
the idea of what I want. And there's no reason to have it RFC. The next
series may still not be ready to go in, but that's why we have v2, v3,
v4... notations ;-)

-- Steve
