Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442D8C3A5A7
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Dec 2022 20:32:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiLFUcu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Dec 2022 15:32:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiLFUcr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Dec 2022 15:32:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3DD3B5
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Dec 2022 12:32:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FF67618B9
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Dec 2022 20:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D79C433C1;
        Tue,  6 Dec 2022 20:32:43 +0000 (UTC)
Date:   Tue, 6 Dec 2022 15:32:40 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: Re: [PATCH v2 2/2] libtraceevent: Pretty-print cpumask fields as a
 cpulist
Message-ID: <20221206153240.737e378b@gandalf.local.home>
In-Reply-To: <20221116144646.3664012-1-vschneid@redhat.com>
References: <20221116144154.3662923-1-vschneid@redhat.com>
        <20221116144646.3664012-1-vschneid@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Nov 2022 14:46:46 +0000
Valentin Schneider <vschneid@redhat.com> wrote:

> +static void print_cpumask_to_seq(struct tep_handle *tep,
> +				 struct trace_seq *s, const char *format,
> +				 int len_arg, const void *data, int size)
> +{
> +	int firstone = -1, firstzero = -1;
> +	int nr_bits = size * 8;
> +	bool first = true;
> +	int str_size = 0;
> +	char buf[12]; /* '-' + log10(2^32) + 1 digits + '\0' */
> +	char *str;
> +	int index;
> +	int i;
> +
> +	str = malloc(cpumask_worst_size(nr_bits) + 1);
> +	if (!str) {
> +		do_warning("%s: not enough memory!", __func__);
> +		return;
> +	}
> +
> +	for (i = 0; i < size; i++) {
> +		unsigned char byte;
> +		int fmtsize;
> +
> +		if (tep->file_bigendian)
> +			index = size - (i + 1);
> +		else
> +			index = i;
> +
> +		/* Byte by byte scan, not the best... */
> +		byte = *(((unsigned char *)data) + index);
> +more:
> +		/* First find a bit set to one...*/
> +		if (firstone < 0 && byte) {
> +			/*
> +			 * Set all lower bits, so a later ffz on this same byte
> +			 * is guaranteed to find a later bit.
> +			 */
> +			firstone = ffs(byte) - 1;
> +			byte |= (1 << firstone) - 1;
> +			firstone += i * 8;
> +		}
> +
> +		if (firstone < 0)
> +			continue;
> +
> +		/* ...Then find a bit set to zero */
> +		if ((~byte) & 0xFF) {
> +			/*
> +			 * Clear all lower bits, so a later ffs on this same
> +			 * byte is guaranteed to find a later bit.
> +			 */
> +			firstzero = ffs(~byte) - 1;
> +			byte &= ~((1 << (firstzero)) - 1);
> +			firstzero += i * 8;
> +		} else if (i == size - 1) { /* ...Or reach the end of the mask */
> +			firstzero = nr_bits;
> +			byte = 0;
> +		} else {
> +			continue;
> +		}
> +
> +		/* We've found a bit set to one, and a later bit set to zero. */
> +		if (!first) {
> +			str[str_size] = ',';
> +			str_size++;
> +		}
> +		first = false;
> +
> +		/* It takes {log10(number) + 1} chars to format a number */
> +		fmtsize = log10(firstone) + 1;
> +		snprintf(buf, fmtsize + 1, "%d", firstone);
> +		memcpy(str + str_size, buf, fmtsize);
> +		str_size += fmtsize;
> +
> +		if (firstzero > firstone + 1) {
> +			fmtsize = log10(firstzero - 1) + 2;
> +			snprintf(buf, fmtsize + 1, "-%d", firstzero - 1);
> +			memcpy(str + str_size, buf, fmtsize);
> +			str_size += fmtsize;
> +		}
> +
> +		firstzero = firstone = -1;
> +		if (byte)
> +			goto more;
> +	}
> +
> +	str[str_size] = 0;
> +	str_size++;
> +
> +	if (len_arg >= 0)
> +		trace_seq_printf(s, format, len_arg, str);
> +	else
> +		trace_seq_printf(s, format, str);
> +
> +	free(str);
> +}
> +


This is a rather complex algorithm (I'm too tired to try to grasp it). It
really needs a unit test to make sure it's working as expected.

-- Steve
