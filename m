Return-Path: <SRS0=S9Jt=ON=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:58180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbeLDWem (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 Dec 2018 17:34:42 -0500
Date: Tue, 4 Dec 2018 17:34:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Slavomir Kaslev <kaslevs@vmware.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/2] trace-cmd: Resend record --date fix
Message-ID: <20181204173439.5e5f10dc@vmware.local.home>
In-Reply-To: <20181203160937.5285-1-kaslevs@vmware.com>
References: <20181203160937.5285-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon,  3 Dec 2018 18:09:35 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> Resending "trace-cmd record --date" fix while keeping backward compatibility.
> 
> Ideally those two patches should land together since the second one assumes that
> all v3 listeners follow new behavior and don't write options in the trace file.
> 
> Slavomir Kaslev (2):
>   trace-cmd: Bump protocol version to v3
>   trace-cmd: Fix record --date flag when sending tracing data to a
>     listener
> 

Note, both patches do not have a signed-off-by. Can you resend with
that fixed.

Thanks!

-- Steve
