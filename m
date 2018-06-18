Return-Path: <SRS0=txqx=JE=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:39994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754110AbeFRP2O (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Jun 2018 11:28:14 -0400
Date: Mon, 18 Jun 2018 11:28:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 4/4] trace-filter: Change the hashing function used when
 filtering
Message-ID: <20180618112812.2d566ea8@gandalf.local.home>
In-Reply-To: <20180615212131.28121-5-y.karadz@gmail.com>
References: <20180615212131.28121-1-y.karadz@gmail.com>
        <20180615212131.28121-5-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Sat, 16 Jun 2018 00:21:31 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The hashing function used in trace-filter-hash is changed.
> The new hashing functions is based on the Donald E. Knuth's
> Multiplicative hashing suggested in his book "The Art of
> Computer Programming". This improves the performance, but
> also removes the restrictions resulting  from using the
> Paul Hsieh's super fast hash, published under the terms of
> the GPL 2.0 license.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  kernel-shark/include/trace-filter-hash.h | 37 +++++++++++++++++++++++-
>  kernel-shark/trace-filter-hash.c         |  6 ++--
>  kernel-shark/trace-graph.c               |  1 +
>  kernel-shark/trace-plot-cpu.c            |  1 +
>  kernel-shark/trace-plot-task.c           |  1 +
>  kernel-shark/trace-plot.c                |  1 +
>  6 files changed, 43 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel-shark/include/trace-filter-hash.h b/kernel-shark/include/trace-filter-hash.h
> index 5cc39dc..98c9ab3 100644
> --- a/kernel-shark/include/trace-filter-hash.h
> +++ b/kernel-shark/include/trace-filter-hash.h
> @@ -20,7 +20,7 @@
>  #ifndef _TRACE_FILTER_HASH_H
>  #define _TRACE_FILTER_HASH_H
>  
> -#include "trace-hash-local.h"
> +#include <stdint.h>
>  


> diff --git a/kernel-shark/trace-graph.c b/kernel-shark/trace-graph.c
> index b652297..1aba417 100644
> --- a/kernel-shark/trace-graph.c
> +++ b/kernel-shark/trace-graph.c
> @@ -33,6 +33,7 @@
>  #include "trace-graph.h"
>  #include "trace-filter-hash.h"
>  #include "trace-filter.h"
> +#include "trace-hash-local.h"
>  #include "trace-gui.h"
>  
>  #include "event-utils.h"
> diff --git a/kernel-shark/trace-plot-cpu.c b/kernel-shark/trace-plot-cpu.c
> index 8374809..d2a0523 100644
> --- a/kernel-shark/trace-plot-cpu.c
> +++ b/kernel-shark/trace-plot-cpu.c
> @@ -22,6 +22,7 @@
>  
>  #include "trace-graph.h"
>  #include "trace-local.h"
> +#include "trace-hash-local.h"
>  #include "cpu.h"
>  
>  struct cpu_plot_info {
> diff --git a/kernel-shark/trace-plot-task.c b/kernel-shark/trace-plot-task.c
> index 3b7e81f..c846221 100644
> --- a/kernel-shark/trace-plot-task.c
> +++ b/kernel-shark/trace-plot-task.c
> @@ -23,6 +23,7 @@
>  #include "trace-graph.h"
>  #include "trace-filter.h"
>  #include "trace-local.h"
> +#include "trace-hash-local.h"
>  
>  #define RED 0xff
>  #define GREEN (0xff<<16)
> diff --git a/kernel-shark/trace-plot.c b/kernel-shark/trace-plot.c
> index dc5b3af..bf2cec0 100644
> --- a/kernel-shark/trace-plot.c
> +++ b/kernel-shark/trace-plot.c
> @@ -21,6 +21,7 @@
>  #include <string.h>
>  #include "trace-graph.h"
>  #include "trace-local.h"
> +#include "trace-hash-local.h"

The change log doesn't explain the header modifications needed here.
Please include that.

Thanks Yordan!

-- Steve

>  
>  void trace_graph_plot_free(struct graph_info *ginfo)
>  {
