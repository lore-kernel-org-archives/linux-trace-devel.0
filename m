Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF39B1E9B3C
	for <linux-trace-devel@vger.kernel.org>; Thu, 10 Apr 2025 02:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744253689; cv=none; b=YI0YI0smUB/1y1avxLwcVmwPC3yF7jH33ggMH5SRZRW7HFgVcx4f/7W6wCoGtp1tSswbUXF+CrenrTzDbFE9CtO/+Hnt2E5LK8Pq7F4uPX7VOixbaoHoRhGvnSnYm2ftHIfJyjpxE+IX5A0lLBWHogJyRZOGBByKTel8e3/cCKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744253689; c=relaxed/simple;
	bh=TIVQ2jepmO2ar58WTnujttjxkPBj7wOrwTCFbQqwpuA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MdosoctjZiphP8levJ9skuRSuhCs5zg48BsIVy1yXxizfQTa7XQ361fYnMxNJsX8nIhdhv6iLDUuZfOtTNYkBAvV6O5aqk8ZDDkhRARe+2+GuCAw1IbEOU5nmsArbXL9XOI6Vxk5IkDsQjcPTMOZR6B1cMgLAaGyPebCMSyWkuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E01C4CEE9;
	Thu, 10 Apr 2025 02:54:47 +0000 (UTC)
Date: Wed, 9 Apr 2025 22:56:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Malat <oss@malat.biz>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent plugins: Add plugin_net to handle bswap
 during print
Message-ID: <20250409225608.12df6ed8@gandalf.local.home>
In-Reply-To: <20250409110705.437321-1-oss@malat.biz>
References: <20250409110705.437321-1-oss@malat.biz>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  9 Apr 2025 13:07:05 +0200
Petr Malat <oss@malat.biz> wrote:

> +static unsigned long long
> +process_builtin_bswap16(struct trace_seq *s, unsigned long long *args)
> +{
> +	return __builtin_bswap16((uint16_t)args[0]);
> +}
> +
> +static unsigned long long
> +process_builtin_bswap32(struct trace_seq *s, unsigned long long *args)
> +{
> +	return __builtin_bswap32((uint32_t)args[0]);
> +}
> +
> +static unsigned long long
> +process_builtin_bswap64(struct trace_seq *s, unsigned long long *args)
> +{
> +	return __builtin_bswap64(args[0]);
> +}
> +

These actually look useful to be built into the main parser itself and not
necessarily in a plugin.

But I'm not sure we can just translate it directly here.

What if the trace.dat is created on a big endian machine, but read on a
little endian machine? I don't think we want to do the byte swapping, do we?

I think this needs to check the file vs host endianess. If they don't match,
I think we don't want to do the swap!

  if (tep->file_bigendian == tep->host_bigendian)
	return __builtin_bswap*(args[0]);
  else
	return args[0];

?

As the else block will have args[0] already swapped wrt to host that's
reading the information. libtraceevent does a byte swap on values read when
the host and file do not match endianess.

-- Steve
