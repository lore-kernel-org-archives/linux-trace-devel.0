Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B359340FDAC
	for <linux-trace-devel@vger.kernel.org>; Wed, 13 May 2026 12:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778676716; cv=none; b=fXtUmGyG2NwWArgMHpFaqpEwbAuGYiEEAxUl5dCS4qX8oJvr71q7lPQxdMGVGEEevYv72N1JPN/CuaNpa2mgdmvZ+DtMSsX2ga7LUNHy8R8ZN8+sP/Lug2T9d2Snih7upXlly7ZiD/8kL+TFS3irQi+GLBxNfQ+t7r57l3bnrPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778676716; c=relaxed/simple;
	bh=Ae44SdagzvdseVOvRQrSdQaIYn3COCC4ZxIbFDVlF30=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WHkH8HzjrGS2Mkie4ekd//JtN/9yNbwvg3GxBITJBlQbxLk+3Rb38VXxVoua+b0yxbM0FtHHx6IK6h6B8PtFwLZs1A34vEB0qGsQAjBA2bVjbb5HEwoEgXZQJpve0pfhnC+TEozDRvN/UV9YDPZ4YbMZ6VhtHRBAVvpYG4wDR5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C2B01C0629;
	Wed, 13 May 2026 12:51:48 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id A46786000C;
	Wed, 13 May 2026 12:51:46 +0000 (UTC)
Date: Wed, 13 May 2026 08:51:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: =?UTF-8?B?5p2O6bmP6aOe?= <ljdlns1987@gmail.com>
Cc: lipengfei28@xiaomi.com, linux-trace-devel@vger.kernel.org
Subject: Re: [RFC IDEA] ftrace: stack trace deduplication in ring buffer
Message-ID: <20260513085145.30dd23e0@fedora>
In-Reply-To: <CALd=Voi=jdM027HTUL01iRnsShcD+rRj5zbRczEN_y4qZ8QQVA@mail.gmail.com>
References: <CALd=Voi=jdM027HTUL01iRnsShcD+rRj5zbRczEN_y4qZ8QQVA@mail.gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: A46786000C
X-Stat-Signature: nqp6117pntz9surou9d44p7qy578ukoh
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/4/Rno6zdYTs1eXzsJ7l+nib8JZ/VOj9o=
X-HE-Tag: 1778676706-29307
X-HE-Meta: U2FsdGVkX199d/g6fuPtDktfWZJdaa/l9jQaL7xfgV2tL+zoAj0X3vpc8QeTwZ/IZdrKzgo+T+IS811smbQgc6/FyPSbOSzWYLyBCodAjIqpzt+QSvrjDvurMcXu0Euj+YGGNajnw4/vnxTzIWZ0pVFc07W6pn1+cncAFpKFmgxhW3Hgqng6XqjYEmV+YPxLnJ/ij6Ckoh+nEKfXqXAGgPyACs8R+lioxOBBLaoI32UYKfYesUohBLIyn1rtT4hTeXy+bfZ8J0ZK5OwNR/wgBK+PLp6YitwsT41cGUdY8jSqsaCEln7N63EoZY8qmvdB0YHMwMGnX/SIuZz0bg++eck2/L+EjzSF

On Wed, 13 May 2026 11:55:24 +0800
=E6=9D=8E=E9=B9=8F=E9=A3=9E <ljdlns1987@gmail.com> wrote:

> My question: is this something you'd consider for upstream ftrace,
> or do you feel this belongs in the eBPF/perf domain? If you're open
> to it, I'll prepare a proper RFC patch series addressing:

Yes, this looks appropriate for the tracefs infrastructure.

> - Pre-allocated bucket pool (no GFP_ATOMIC in trace path)

Have you looked at the tracing_map.c code that handles the histograms
for trace events?

> - Per-trace_array instance support
> - rhashtable or similar proven data structure
> - trace-cmd/libtraceevent plugin for stack_id resolution

If it is a standard format that is not expected to change, then it
could simply go into the libtraceevent core.

Thanks,

-- Steve

