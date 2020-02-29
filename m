Return-Path: <SRS0=9dw+=4R=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6284C3F2D2
	for <linux-trace-devel@archiver.kernel.org>; Sat, 29 Feb 2020 00:28:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C2EA2469D
	for <linux-trace-devel@archiver.kernel.org>; Sat, 29 Feb 2020 00:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgB2A2O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 28 Feb 2020 19:28:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:39292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725957AbgB2A2O (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 28 Feb 2020 19:28:14 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EF5E2469D;
        Sat, 29 Feb 2020 00:28:13 +0000 (UTC)
Date:   Fri, 28 Feb 2020 19:28:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v20 13/15] trace-cmd: Basic infrastructure for host -
 guest timestamp synchronization
Message-ID: <20200228192811.77831fc9@gandalf.local.home>
In-Reply-To: <20200227142001.61577-14-tz.stoyanov@gmail.com>
References: <20200227142001.61577-1-tz.stoyanov@gmail.com>
        <20200227142001.61577-14-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Now that I'm playing with patch 14, I took more interest in this code.

On Thu, 27 Feb 2020 16:19:59 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +
> +#define PROTO_MASK_SIZE (sizeof(char))

Hmm, this is the size in bytes of the mask, not bits. You may need both.

#define PROTO_MASK_BITS (PROTO_MASK_SIZE * 8)

Because we can have up to 8 protocols per mask size (8 bits in a byte).

> +/**
> + * tracecmd_tsync_proto_select - Select time sync protocol, to be used for
> + *		timestamp synchronization with a peer
> + *
> + * @proto_mask: bitmask array of time sync protocols, supported by the peer
> + * @length: size of the @protos array
> + *
> + * Retuns Id of a time sync protocol, that can be used with the peer, or 0
> + *	  in case there is no match with supported protocols
> + */
> +unsigned int tracecmd_tsync_proto_select(char *proto_mask, int length)
> +{
> +	struct tsync_proto *selected = NULL;
> +	struct tsync_proto *proto;
> +	int word;
> +	int id;
> +
> +	for (word = 0; word < length; word++) {
> +		for (proto = tsync_proto_list; proto; proto = proto->next) {
> +			if (proto->proto_id < word * PROTO_MASK_SIZE)
> +				continue;

The above should be: proto->proto_id < word * PROTO_MASK_BITS

Because what you have currently is:

   proto->proto_id < word * 1


> +
> +			id = proto->proto_id - word * PROTO_MASK_SIZE;

And here you want PROTO_MASK_BITS, otherwise if we have a proto_id of 2
(which would fit as a bit in a char), this would become:

	id = 2 - 0 * 1 = 1

> +			if (id >= PROTO_MASK_SIZE)

Then this is: 2 >= 1 which would skip it.

Hmm, maybe you don't even need PROTO_MASK_SIZE and only need
PROTO_MASK_BITS.

-- Steve

> +				continue;
> +
> +			if ((1 << id) & proto_mask[word]) {
> +				if (selected) {
> +					if (selected->weight < proto->weight)
> +						selected = proto;
> +				} else
> +					selected = proto;
> +			}
> +		}
> +	}
> +
> +	if (selected)
> +		return selected->proto_id;
> +
> +	return 0;
> +}
> +
