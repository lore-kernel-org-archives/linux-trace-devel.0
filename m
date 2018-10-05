Return-Path: <SRS0=Wk/S=MR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:45566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727572AbeJEWnW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Oct 2018 18:43:22 -0400
Date: Fri, 5 Oct 2018 11:44:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: Yordan Karadzhov <ykaradzhov@vmware.com>,
        "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] kernel-shark-qt: Add kshark_get_X_easy()
 functions.
Message-ID: <20181005114405.365ba90e@gandalf.local.home>
In-Reply-To: <ad5dcd71-aa99-f2d0-f586-8f8af9e03bab@gmail.com>
References: <20181001135921.32379-1-ykaradzhov@vmware.com>
        <20181001135921.32379-2-ykaradzhov@vmware.com>
        <20181002164420.37d75e18@gandalf.local.home>
        <dce5ae6d-900e-c612-2bae-81d2ad25a0a3@vmware.com>
        <5914b819-62eb-f2be-ba74-b12f138452fc@gmail.com>
        <20181005104607.0f205018@gandalf.local.home>
        <ad5dcd71-aa99-f2d0-f586-8f8af9e03bab@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 5 Oct 2018 18:27:20 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:


> If the value of "entry->pid" has been changed then the new value will be 
> used when plotting graphs and we do not want to change this.
> However, we still want to be able to retrieve the original value. The 
> description of the function explains that it will return the original value.

Right. I wanted to figure out why we have two values for pid?

OK, just clarifying what was the intent.

Please send v3 with the other updates.

Thanks!

-- Steve
