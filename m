Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:45528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933574AbdLRVnM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Dec 2017 16:43:12 -0500
Date: Mon, 18 Dec 2017 16:43:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: David Hildenbrand <david@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v1] trace-cmd: introduce --initital-delay for record
 command
Message-ID: <20171218164308.658924b8@gandalf.local.home>
In-Reply-To: <55abd06d-1cac-8deb-d9be-f661f0ba30e1@redhat.com>
References: <20171218112412.11898-1-david@redhat.com>
        <20171218104158.22519a7e@gandalf.local.home>
        <7b89f63f-3a6f-4182-c26a-934514ba5670@redhat.com>
        <20171218125231.445d8fa2@gandalf.local.home>
        <55abd06d-1cac-8deb-d9be-f661f0ba30e1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon, 18 Dec 2017 21:56:33 +0100
David Hildenbrand <david@redhat.com> wrote:
 
> I'll have a try tomorrow if I I''lose events with 20MB buffers per CPU
> when recording more than 60 seconds (on a very active system with
> mentioned scheduler rtaces being turned on).
>

Another option is to add a '-w' option to record that causes the
recorders (what reads the data) to "wait" or force it to sleep even if
it did read something. I'm fine with that.

-- Steve
