Return-Path: <SRS0=R/5S=OM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:58194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbeLCQSR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 3 Dec 2018 11:18:17 -0500
Date: Mon, 3 Dec 2018 11:18:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Slavomir Kaslev <kaslevs@vmware.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] trace-cmd: Bump protocol version to v3
Message-ID: <20181203111804.717abf40@vmware.local.home>
In-Reply-To: <20181203160937.5285-2-kaslevs@vmware.com>
References: <20181203160937.5285-1-kaslevs@vmware.com>
        <20181203160937.5285-2-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon,  3 Dec 2018 18:09:36 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> This patch bumps trace-cmd protocol to v3 while keeping backward compatibility
> by falling back to v1.
> 
> The new protocol works similarly to v2 but allows future extension of commands
> by saving the command size on the wire and having the client on the other side
> to only read the bits it understands.
> 

So is this a V3 that is ready for prime time?

That is, you are happy with the protocol and that old code will work
with the new (as we talked about before).

-- Steve
