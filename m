Return-Path: <SRS0=XDEQ=MW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:41872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbeJKCZu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Oct 2018 22:25:50 -0400
Date: Wed, 10 Oct 2018 15:02:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/4] kernel-shark-qt: Add KernalShark Utils
Message-ID: <20181010150220.008be84a@gandalf.local.home>
In-Reply-To: <2a8bf041-2fe6-9464-4795-f06b4bdad0e2@vmware.com>
References: <20181008151629.13973-1-ykaradzhov@vmware.com>
        <20181008151629.13973-3-ykaradzhov@vmware.com>
        <20181009123419.22fe49f2@gandalf.local.home>
        <4eb2711d-5462-26a7-3ffb-a71035322521@vmware.com>
        <20181010112214.320b61fc@gandalf.local.home>
        <2a8bf041-2fe6-9464-4795-f06b4bdad0e2@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 10 Oct 2018 18:25:52 +0300
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> > Actually, there are real uses to do both. You may want to show a
> > specific kind of event, and then you may want to filter a subset of
> > that event.
> >   
> 
> But if you want to filter a subset of one event you have to use the 
> advanced filtering, while the logic in the "switch" is only for the "Id 
> filters".

I guess I was thinking about filtering to show all events under a
specific system, and then hiding events from within that system, but it
probably is just easier to pick those events not to show in the gui (I
was playing with the old KS to see how it did things).

-- Steve
