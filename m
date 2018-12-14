Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:34482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728203AbeLNBiz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Dec 2018 20:38:55 -0500
Date: Thu, 13 Dec 2018 20:38:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Slavomir Kaslev <kaslevs@vmware.com>
Cc: linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH v3 3/3] trace-cmd: Fix record --date flag when sending
 tracing data to a listener
Message-ID: <20181213203852.5989aa28@vmware.local.home>
In-Reply-To: <20181212111711.30990a0f@gandalf.local.home>
References: <20181205091524.4789-1-kaslevs@vmware.com>
        <20181205091524.4789-4-kaslevs@vmware.com>
        <20181212111711.30990a0f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 12 Dec 2018 11:17:11 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Let's break this function up, and have the caller deal with a
> tracecmd_output *handle.
> 
> We can have:
> 
> 	handle = tracecmd_get_output_handle_fd(ofd);
> 	if (write_options) {
> 		tracecmd_write_cpus(handle, cpus);
> 		tracecmd_write_options(handle);
> 	}
> 	tracecmd_write_cpu_data(handle, cpus, temp_files);
> 
> Also, let's have this patch come before patch 2/3, such that there's no
> path to write the options until the boosting to v3.

Hi Slavomir,

Have you had a chance to do these changes yet and send out a v4?

Thanks,

-- Steve
