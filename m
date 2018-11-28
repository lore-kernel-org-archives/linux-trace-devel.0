Return-Path: <SRS0=agpe=OH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:37700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728953AbeK2EO0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 23:14:26 -0500
Date: Wed, 28 Nov 2018 12:12:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 11/17] kernel-shark-qt: Sort all graphs before plotting
Message-ID: <20181128121204.24ae02dd@gandalf.local.home>
In-Reply-To: <20181128151530.21965-12-ykaradzhov@vmware.com>
References: <20181128151530.21965-1-ykaradzhov@vmware.com>
        <20181128151530.21965-12-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 28 Nov 2018 15:16:20 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> The CPU/Task graphs are plotted in sorted order. The graph
> having smallest CPU id/Pid will be plotted first (on top).

I'm fine with this. But I'm wondering if we want to allow the user to
move the plots in the future, if that would be a big design change or
not.

-- Steve

> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark-qt/src/KsTraceGraph.cpp | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel-shark-qt/src/KsTraceGraph.cpp b/kernel-shark-qt/src/KsTraceGraph.cpp
> index 09b322a..0b5a8b1 100644
> --- a/kernel-shark-qt/src/KsTraceGraph.cpp
> +++ b/kernel-shark-qt/src/KsTraceGraph.cpp
> @@ -439,6 +439,7 @@ void KsTraceGraph::addCPUPlot(int cpu)
>  		return;
>  
>  	_glWindow._cpuList.append(cpu);
> +	qSort(_glWindow._cpuList);
>  	_selfUpdate();
>  }
>  
> @@ -449,6 +450,7 @@ void KsTraceGraph::addTaskPlot(int pid)
>  		return;
>  
>  	_glWindow._taskList.append(pid);
> +	qSort(_glWindow._taskList);
>  	_selfUpdate();
>  }
>  
