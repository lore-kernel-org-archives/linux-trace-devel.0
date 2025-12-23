Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3642C15AB
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Dec 2025 20:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766522840; cv=none; b=txWkIOfyl18+QZG78YybP1jhHyqBFKTD9SGKGiWVCTnCnCzZqsEn3bFWg1vgs7k4O5gNrm7m4O4TnVnU8P8e1/mLTjNe1LAjE7MkLEIz6ye7qa46jQEE+ht1NUcSQH3svZo1jWMASokb0La8R5xXzrFc9QxjJzG7R+ydfcdZvrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766522840; c=relaxed/simple;
	bh=psTiAlxcdvVinoSlADwtRv4fI7RNxlnBO3Z+4QJgGvo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hs/5T4MVbWapgULLbyt7s60atFVI5Z2zX6v9c+iZfZWcDnJld3Ibm9QG6V2aof0DMefqVoKv1fups9MwRqt23u6++T8ZzeM89FVoO7YF+CL63QOxI45u6zJidPee7uJkp5z2lXncMCTDmXJCWa9ZIHCcoivotS1nW54MVD9/yTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BA2D8B519;
	Tue, 23 Dec 2025 20:47:11 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf06.hostedemail.com (Postfix) with ESMTPA id AFBC92000F;
	Tue, 23 Dec 2025 20:47:09 +0000 (UTC)
Date: Tue, 23 Dec 2025 15:49:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Wenjun Huo <huowenjun.dev@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: trace-cmd: question about explicit host endianness setting
Message-ID: <20251223154900.717ab7ec@gandalf.local.home>
In-Reply-To: <20251223144221.1624-1-huowenjun.dev@gmail.com>
References: <20251223144221.1624-1-huowenjun.dev@gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: spwodzi517imfw719s5nhhe4d1efjqy9
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: AFBC92000F
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/H/iqFQDt8bQT26yJXsfgN2UuVM5I8dig=
X-HE-Tag: 1766522829-997371
X-HE-Meta: U2FsdGVkX1/vMjDcBBJv76izpM9JtPNwVcnyO6MbkXtNfdLmAHz1YdwPLlQcxmnmUQnGGEN9yYDi71WhLQg1TLcWKzQ82svd9X3nMldcp+JgeF7dH4eer3tuzu+b37BtROHVOujtkxbBxb98Syip89NqahZvsqlq/JPBTSWqt58K8571SA793VfGDEqN9s0el1axhONjewednKvmztoobIIkfusW7Ac7PCK1Ve2/QeR/iA+XRUblem43qOcGCEke9Dvmz8aJpGvgb89/63NBYKBz/sZTqf68iDY2T1zvcdtiTXcfIltGTNY4uoAJzb8iAnANBQxGB/5WTHU6DiYYiPyEtPEOvKed

On Tue, 23 Dec 2025 22:42:21 +0800
Wenjun Huo <huowenjun.dev@gmail.com> wrote:

> Dear Tracers,
> 
> While reading the trace-cmd code, I noticed a detail in
> tracecmd_alloc_fd() regarding endianness handling and wanted to
> double-check my understanding.
> 
> In tracecmd_alloc_fd(), after tep_alloc() and plugin loading,
> trace-cmd explicitly sets both file and local endianness:
> 
> tep_set_file_bigendian(handle->pevent, buf[0]);
> tep_set_local_bigendian(handle->pevent, tracecmd_host_bigendian());
> 
> I understand that setting the file endianness here is required,
> since it is read from the trace file header.
> 
> For the local/host endianness, tep_alloc() already initializes
> host_bigendian via tep_is_bigendian(), and in the common case
> tracecmd_host_bigendian() resolves to the same value. So in practice
> this explicit call usually does not change the value.
> 
> My understanding is that this is intentional, and that the call to
> tep_set_local_bigendian() serves as an explicit binding step, making
> it clear that trace-cmd confirms the local execution endianness
> after parsing the trace header and loading plugins, rather than
> relying on tep_alloc() defaults.
> 
> Could you please confirm if this interpretation is correct, and
> whether this explicit setting is mainly for clarity / defensive API
> usage rather than functional necessity?

Nope, it's simply due to legacy and the evolution of software. Sort of why
we still have an appendix ;-)

If you look at trace-cmd commit cd001f7b40f9d ("Add handler to pevent
functions") [ from 2009! ] it has:

+       handle->pevent = pevent_alloc();
+       if (!handle->pevent)
+               goto failed_read;
+
+       handle->pevent->file_bigendian = buf[0];
+       handle->pevent->host_bigendian = bigendian();
 
Where at that time, pevent_alloc() was simply:

struct tep_handle *pevent_alloc(void)
{
        struct tep_handle *pevent = calloc(1, sizeof(*pevent));

        if (pevent)
                pevent->ref_count = 1;

        return pevent;
}

and trace-cmd had to set the file and host endianess.

But since then, libtraceevent renamed pevent_alloc() to tep_alloc() and
initialized the host_bigendian.

trace-cmd was updated to simply keep the original code but modified to have
the new APIs.

> 
> If maintainers think there is a better way to clarify or improve
> this behavior (for example via comments, documentation, or code
> adjustments), I would be very happy to help by preparing and sending
> a patch based on your guidance.

In reality, the line:

	tep_set_local_bigendian(handle->pevent, tracecmd_host_bigendian());

is obsolete, and probably could just be deleted.

If you want to send that patch feel free, or I can simply remove it.

Thanks for your curiosity of looking at this code ;-)

-- Steve
