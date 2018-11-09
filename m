Return-Path: <SRS0=pNTI=NU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:58844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727157AbeKILuq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Nov 2018 06:50:46 -0500
Date: Thu, 8 Nov 2018 21:12:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 6/8] kernel-shark-qt: Add tot_count field to the model
 descriptor
Message-ID: <20181108211218.2046b73e@vmware.local.home>
In-Reply-To: <20181107161410.22507-7-ykaradzhov@vmware.com>
References: <20181107161410.22507-1-ykaradzhov@vmware.com>
        <20181107161410.22507-7-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 7 Nov 2018 16:14:38 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> The tot_count field of the Visualization model descriptor provides
> fast access to the total number of entries being currently visualized.

I'm pulling these patches as is, but just for the future, it's best to
add a bit more about "why" a change like this is added. You could add
something like:

 "This will be useful for the sched event plugin for knowing when to
 plot wakeup latency"

Or something like that.

-- Steve


> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
>
