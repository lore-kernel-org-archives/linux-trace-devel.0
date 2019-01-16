Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7909C43387
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 16:41:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B94DC20675
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 16:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbfAPQl4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Jan 2019 11:41:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:42988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfAPQl4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Jan 2019 11:41:56 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5005A20657;
        Wed, 16 Jan 2019 16:41:55 +0000 (UTC)
Date:   Wed, 16 Jan 2019 11:41:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 09/46] tools/lib/traceevent: Man page for
 tep_is_host_bigendian() and tep_set_host_bigendian()
Message-ID: <20190116114153.70acf2c3@gandalf.local.home>
In-Reply-To: <20181127154153.11315-10-tstoyanov@vmware.com>
References: <20181127154153.11315-1-tstoyanov@vmware.com>
        <20181127154153.11315-10-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 27 Nov 2018 15:42:17 +0000
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man pages for tep_is_host_bigendian() and tep_set_host_bigendian()
> as part of the libtraceevent APIs.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-host_endian.txt             | 90 +++++++++++++++++++
>  1 file changed, 90 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt b/tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
> new file mode 100644
> index 000000000000..250eb430c06a
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-host_endian.txt
> @@ -0,0 +1,90 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_is_host_bigendian,tep_set_host_bigendian,tep_host_bigendian - Get / set the endianess of 
> +the machine running the current code.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +enum *tep_endian* {
> +	TEP_LITTLE_ENDIAN = 0,
> +	TEP_BIG_ENDIAN
> +};
> +
> +int *tep_is_host_bigendian*(struct tep_handle pass:[*]_tep_);
> +void *tep_set_host_bigendian*(struct tep_handle pass:[*]_tep_, enum tep_endian _endian_);
> +int tep_host_bigendian(void);
> +--
> +
> +DESCRIPTION
> +-----------
> +The _tep_is_host_bigendian()_ function returns the endianess of the the machine 
> +running the current code. The _tep_ argument is trace event parser context.
> +
> +The _tep_set_host_bigendian()_ set the endianess of the machine running the code.
> +The _tep_ argument is trace event parser context. The _endian_ argument is the endianess:
> +[verse]

FYI,

I changed the above to to read "_tep_ argument is the trace event
parser context"

-- Steve

> +--
>
