Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727829AbfAHWkY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Jan 2019 17:40:24 -0500
Date: Tue, 8 Jan 2019 17:40:21 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Slavomir Kaslev <kaslevs@vmware.com>
Cc: linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        tstoyanov@vmware.com
Subject: Re: [PATCH v2 4/6] trace-cmd: Simplify and fix memory leaks in
 tracecmd_msg_collect_data
Message-ID: <20190108174021.23cdcf6f@gandalf.local.home>
In-Reply-To: <20190108150015.21327-5-kaslevs@vmware.com>
References: <20190108150015.21327-1-kaslevs@vmware.com>
        <20190108150015.21327-5-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue,  8 Jan 2019 17:00:13 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> This patch addresses leaking tracecmd_msg messages in tracecmd_msg_collect_data.
> 
> It also splits out tracecmd_msg_read_data from tracecmd_msg_collect_data which
> only reads incomming data and doesn't wait for a final MSG_CLOSE message and is
> used by the VM tracing agent.
>

I re-ordered the patch series and made this patch 3/6 and made the
original 3/6 the 4/6. The first 3 patches (including this one) are
being pulled into the main branch.

I'll keep the virt-server branch separate still.

-- Steve
