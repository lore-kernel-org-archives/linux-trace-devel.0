Return-Path: <SRS0=62yJ=JP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:47108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934360AbeF2SfA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Jun 2018 14:35:00 -0400
Date: Fri, 29 Jun 2018 14:34:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 3/9] kernel-shark-qt: Add API for loading trace.dat
 files
Message-ID: <20180629143458.07e50efa@gandalf.local.home>
In-Reply-To: <20180629142911.722d9314@gandalf.local.home>
References: <20180629152541.10109-1-y.karadz@gmail.com>
        <20180629152541.10109-4-y.karadz@gmail.com>
        <20180629142911.722d9314@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 29 Jun 2018 14:29:11 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Other than that, the patch looks good, as it looks like you did
> everything I asked. I would have done the rearranging myself, but since
> the realloc and calloc above need error checks, you can submit this one
> again.
> 
> The first two patches are fine, and I'll pull them in so no need to
> resubmit those.
> 
> I'll continue to review the other patches, and if I don't see anything
> wrong with them, then you only need to update this one patch.

The rest of the patches look good. Just resend a v4 of this patch.

Thanks!

-- Steve
