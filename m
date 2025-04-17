Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B702512C5
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Apr 2025 14:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744901821; cv=none; b=H8ZfYTl3DkUrcOYxa61Ck4xucOUV6JsP2TIj6tYHnTvTenAO+FkJ0etKIf3hv/hXZ+Df/IA/NqTwTEhYf/U6zzIpnIALf2F9gmRmrSnmhiNSrEdMI3KqcSJjDyEmpea4EE4PZ9EQC0P6d6hAm4yiGWYcv+TXc7HVsKo9dY6YZx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744901821; c=relaxed/simple;
	bh=usxBGwkNl2B5NQP8osCcVAUVraB3uFDGfOgozmDqFDU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k61Wfdvkazkeiz5A3vPk9xnU1cuvi75dd+XAN547JD2F0/ohKBQy+ZZhZKVrIPFHQA6QBsyF/Iylo6AbocDFvql5sH0j1WylF081T0eloKx+hevlhLE9Bk6S2cislOsQzPbcr6AkXov/vXyXw4VAHSfXSHkhGBT+ghMhaDCHT+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CDFC4CEE4;
	Thu, 17 Apr 2025 14:57:00 +0000 (UTC)
Date: Thu, 17 Apr 2025 10:58:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Malat <oss@malat.biz>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent plugins: Add plugin_net to handle bswap
 during print
Message-ID: <20250417105838.7e80d137@gandalf.local.home>
In-Reply-To: <CANMuvJkUM7m7byL0bRfe2eBb5wB8vhaMV7qzGpTymQ75Rxn0Uw@mail.gmail.com>
References: <20250409110705.437321-1-oss@malat.biz>
	<20250409225608.12df6ed8@gandalf.local.home>
	<20250414114117.6346acc3@gandalf.local.home>
	<CANMuvJmtk8bbQnT1FgnLzidQ_L1uGrdYypTRoyvLkJhUFVUi=g@mail.gmail.com>
	<20250417074900.15044cc2@gandalf.local.home>
	<CANMuvJkUM7m7byL0bRfe2eBb5wB8vhaMV7qzGpTymQ75Rxn0Uw@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 17 Apr 2025 10:39:12 -0400
Petr Malat <oss@malat.biz> wrote:

> Yes, it works (mips is BE):
>  - when trace is taken on mips, then ntohs expands to a cast and there is no
>    __builin_bswap in the print format. When that trace is read, it's then
>    handled as any other number. So on mips nothing is done and on x86 bytes
>    are swapped to translate the number to native ordering.
>  - when trace is taken on x86, then ntohs expands to byte swapping. When that
>    trace is read on x86 it's swapped and correctly printed. When it's read
>    on mips it's swapped twice - once when read due to different endianess and
>    then again due to bswap in print format and again the correct value
> is printed.

Ah, I guess just swapping would always work.

 * If recorded on x86 and we have __builtin_bswap*() so that the number
   read into the buffer is not byte swapped, but should be when printed:

   If read: 0xaabbccdd, it would print: 0xddccbbaa

   But in the file, it is still how it was read (0xaabbccdd).

   Now if the trace.dat file is read on MIPS (BE), it would do the
   conversion when it reads the number:

   Reads 0xaabbccdd but then converts it to 0xddccbbaa, but since it's BE,
   that would be read as a number as: 0xaabbccdd. Then the print fmt would
   have __builtin_bswap32(), and then mips would convert the 0xddccbbaa into
   0xaabbccdd, which being BE it would print: 0xddccbbaa

   By always swapping if the print_fmt says to swap, reading the x86
   trace.dat on both x86 and BE MIPS, would produce the same: 0xddccbbaa.

Then we would always need to swap.

OK, forget my other suggestions, I think this should be fine.

> 
> 
> > That is, do a "trace-cmd record" on a bigendian or little endian machine,
> > then copying the trace.dat file to a machine with the opposite endian, and
> > seeing if it still produces the correct output?
> >
> > BTW, libtraceevent also provides its own swap functions so if the GCC
> > builtin is not always available, then it should use that instead.
> >
> >   See the "tep_data2host*()" fuctions.
> >
> > But that may need to be updated as "tep_swapbytes*()" and have:
> >
> > 	if (!tep || tep->host_bigendian != tep->file_bigendian)
> > 		return data;
> >  
> For some reason I was not able to get your patch working, it always prints
> zeroes instead actual value. I tried to fix it, but no luck, only found copy
> and paste error where you swap 64-bit int as 16-bit. If you want I can share
> some example trace.dat files.

Hmm, I didn't test it myself (just compiled it).

-- Steve
