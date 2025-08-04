Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D212737F0
	for <linux-trace-devel@vger.kernel.org>; Mon,  4 Aug 2025 14:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754318166; cv=none; b=Qk/AqYiE8aUm/y+rZMlQN2dCJ6DPhRfo+CoACbYCduDF/suWEFldgGlqIZX3KzhkGiSiUAXUBJKfYs+jcbfvBnO0CgzHWcE4o9MM/mPDIWeIabnQx+HEJj3+lPhxrMEIjszr5RTop9t3SPGbpc61Xnv+rQL4vMMpZ99bgk3w0pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754318166; c=relaxed/simple;
	bh=GZXdL2SEkkM2QfpLo0F/L59cDUF3meOjI+Jimahboew=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I9pn1Trs5FnFvLmKaxBISMn6rCwiPtwDLFqO0W2A6XNMqbnmREriWzYAYgcHxHdn2iEZ4zbVILRekfbVoUKj+hZX3e9nPgTSrp0RBaDIHN2QcCIIt0sJVAhxTrJFA9uzB6W8Zk97LyywOUV5TG2032rVV2w78cyMUvJzjiPQBck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28293C0625;
	Mon,  4 Aug 2025 14:35:57 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id 323A530;
	Mon,  4 Aug 2025 14:35:55 +0000 (UTC)
Date: Mon, 4 Aug 2025 10:36:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Douglas Raillard <douglas.raillard@arm.com>
Cc: linux-trace-devel@vger.kernel.org, Masami Hiramatsu
 <mhiramat@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Takaya Saeki
 <takayas@google.com>, Ian Rogers <irogers@google.com>, aahringo@redhat.com
Subject: Re: [PATCH 0/5] trace-cmd: Use BTF to parse function arguments
Message-ID: <20250804103622.3b3762e6@gandalf.local.home>
In-Reply-To: <8e75d9d2-8fa2-4232-a00e-2e9bc20d3701@arm.com>
References: <20250731202238.1654368-1-rostedt@goodmis.org>
	<6457bff9-9485-4d2d-82a5-ae436932000a@arm.com>
	<20250804084543.61c4d6c7@gandalf.local.home>
	<8e75d9d2-8fa2-4232-a00e-2e9bc20d3701@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 323A530
X-Stat-Signature: ocdnutcqrodexs4thk86bo5kn5da33cu
X-Rspamd-Server: rspamout02
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18txLKEFiyI427XiVpDF8C+KO1LWFEbBE8=
X-HE-Tag: 1754318155-540435
X-HE-Meta: U2FsdGVkX18TGZAXswdgcDxUK7XGwWN12WlRb8Hg1TTiVEYrS/AX8299VGRF2jEIVCxp5FvjUA0gm9Tzbgwn3Mh3iMo6yu0jDFjqRKkK0RLNTSqDJ9fV3zj51KrPSqvS/j0ebm0f/zBCM57uNs6glTl7ixH7ipy0b3kz3bKkZlGCkqa2daJdJcLFkVz61qHEm8fhzD/fqxy4InzzwK3tPC0krBGwWWKlr/GgMIVTC993HVxYM/BSfSV2sQEc6QnQLvMe0FPh98rhVWinrp1kxSCa1XnFdeogz3+31oj95Q+SqaKOJ2PW1uUY5qIirkHWd4U1MhOlVHwpCnftQ/FSpypAIUWLwewLCo3M/bkR86dro7RnKgQU6JQye1q/GuNO2e1CDb0+wbM00KEUK0Q687aoHmYXqLaqPIP+32n39Z5dbRvW2fyWP+hCBfJoBYgE13iGWgU0CMPrknqALq+Ikw==

On Mon, 4 Aug 2025 15:28:58 +0100
Douglas Raillard <douglas.raillard@arm.com> wrote:

> Sounds like a good idea. If you want to support passing BTF at report time to supplement a BTF-less trace.dat,
> it would make sense to also support getting BTF from the ELF section so that people can pass the real
> vmlinux file directly (not the BTF blob in sysfs, the actual ELF vmlinux from Kbuild).
> 
> It seems libbpf allows to do that with bpf_object__open_file():
> https://docs.ebpf.io/ebpf-library/libbpf/userspace/bpf_object__open_file/
> 

Yeah, but then it adds a dependency that I'm trying to limit.

Parsing elf files for sections is quite trivial. I've done that a lot. I
may just add a: --btf-elf /path/to/elf-file

-- Steve
