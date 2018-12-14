Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:41040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729981AbeLNRR3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Dec 2018 12:17:29 -0500
Date: Fri, 14 Dec 2018 12:17:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 3/8] kernel-shark-qt: Make the parallelized search
 stoppable
Message-ID: <20181214121726.41d23547@gandalf.local.home>
In-Reply-To: <20181214125212.9637-4-ykaradzhov@vmware.com>
References: <20181214125212.9637-1-ykaradzhov@vmware.com>
        <20181214125212.9637-4-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 14 Dec 2018 12:52:37 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> So far only the single-threaded search inside the "Latency" and "Info"
> columns can be stopped by the "stop search" button. This patch makes it
> possible to stop also the parallelized search. Note that after stopping
> the parallelized search, the list of matches will contain entries which
> may not be consecutive, because each thread was searching in its own
> subset of the data and was stoped at an arbitrary position in this
> subset.
> 

Also I noticed:

  _searchStopButton(QIcon::fromTheme("process-stop"), "", this),

I don't have a "process-stop" theme. I'm not running KDE. All I see is
a blank button. Is there a way to add text to it too, or define the
theme if it is not set?

-- Steve
