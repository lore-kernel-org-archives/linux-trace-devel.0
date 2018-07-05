Return-Path: <SRS0=lN8X=JV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:56988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753677AbeGEQ0C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jul 2018 12:26:02 -0400
Date: Thu, 5 Jul 2018 12:25:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel-shark-qt: Consolidate load_data_entries and
 load_data_records
Message-ID: <20180705122559.6e7d6efe@gandalf.local.home>
In-Reply-To: <c76e5486-1431-7a81-63e8-cac67858d5e8@gmail.com>
References: <20180703162432.316240087@goodmis.org>
        <993cf66c-316a-1b7a-59a6-a5f607476667@gmail.com>
        <c76e5486-1431-7a81-63e8-cac67858d5e8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 5 Jul 2018 19:08:58 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Hi Steve,
> I am still learning how to answer to patches, and I guess because of 
> this you didn't notice my comment at the bottom. I think you have to 
> remove the line
> 
>    free_record(rec);

My fault, I should have looked further down. This is why I usually
clean up my replies. By removing functions I'm not commenting on and
replacing them with: [..]

Even with that said, it was my fault for missing it. Thanks for the
review.

> 
> You don't have to send me another patch.

OK, I'll fix it up and push it out.

-- Steve
