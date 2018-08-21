Return-Path: <SRS0=yn/p=LE=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:41852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727942AbeHUS5T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Aug 2018 14:57:19 -0400
Date: Tue, 21 Aug 2018 11:36:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] kernel-shark-qt: Add I/O for configuration data.
Message-ID: <20180821113639.43293ad2@gandalf.local.home>
In-Reply-To: <20180817145845.29651-1-y.karadz@gmail.com>
References: <20180817145845.29651-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 17 Aug 2018 17:58:45 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> Add to the C API of KernelShark instruments for importing/exporting
> configuration settings to/from Json files. A wrapper is added in order
> to abstract out completely the use of Json. This can be useful in the
> future if we want to support multiple formats (YAML for example).
> 
> This version of the patch contains a number of improvements suggested
> by Steven Rostedt. Thanks Steven!
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
>

I pushed the 3 patches upstream.

Thanks Yordan!

-- Steve
