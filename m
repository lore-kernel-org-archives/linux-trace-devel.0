Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249593FF1C0
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2026 18:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780078058; cv=none; b=dxiedmFxFqNX7ypS0MrSNhHoUYjn9/MkvctDQRj0qcY1w8BnWbZOODTJUU1GDTYqk4CL8FU6Laj0mNgpAXUSncDAQPO7zsdzexmhe4TxcHNLs4gUQVKzW/LtqbQgsqnPPJfgQOmM+S1cEZnzDF497RzMl+vVdBMXOYhMtpTR0MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780078058; c=relaxed/simple;
	bh=kOHC4RbKKh3NAhRgotuOvDzVQ0cxig9pBZRsN807lo0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qnqTGWm/TZxyLA5b7edvIlEWrDLZY0WexBmHHxvR3xQZiG3eprECALHnBHPOj0fKKY2lqUdzTNd02GIsOMJ4c4yFKSXV9KsS9dS0pXvndkQqBLFHXVh31UxC7r51spboXVFc6PW50OUMjk504m7vzEbG6p3hBH9rpFxLPOla+3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF30C140254;
	Fri, 29 May 2026 18:07:33 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id 256CC2F;
	Fri, 29 May 2026 18:07:32 +0000 (UTC)
Date: Fri, 29 May 2026 14:07:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: CaoRuichuang <create0818@163.com>
Cc: linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com
Subject: Re: [PATCH v2] libtraceevent: avoid racing recursive builds of both
 libraries
Message-ID: <20260529140730.3ea1859b@fedora>
In-Reply-To: <20260406062855.58598-1-create0818@163.com>
References: <20260405222102.9204-1-create0818@163.com>
	<20260406062855.58598-1-create0818@163.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c6icisnm11wyywz8bqrtmwact1j17gti
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 256CC2F
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/t/v4gU11+bPdSq/XKqbi0lHAIU01TjSY=
X-HE-Tag: 1780078052-843398
X-HE-Meta: U2FsdGVkX1+akUsvm5+TDb9oItkfdS4nKcmjyhpYt8dVYc/OhzzEBl9Xs1rvTG+OMBp5LsBPpUmQQRgECKnN/CCthU6xWOS4d+mBFlu8ybAS3HL6qLbTPXx1LklLJDOSEHHZd3+moHq7urKyUkh5D5/3UEQmsC7+fHMhxOGpFEbVirK9NmKvCfKyNHACWGTjVOujkArc9mLOmVNWbVP5pwnDsePiNr6rg/zf/8dYikvtXw2x5cQT5PMI9iWSh3Hc4Ce44oJdte51LHRoavwJs3TYcJllONg/HcMYz6Yscfnc+qXJ0tIn43S3aAKpSA5SHnhd1ehxuxZIGaZMVLBKp3WhQMlO1P3FQA4NRDJ39tXAM4Up1xX42g==

On Mon,  6 Apr 2026 14:28:55 +0800
CaoRuichuang <create0818@163.com> wrote:

Sorry for the late reply, I've been quite busy on the kernel side of things.

> A top-level parallel build currently starts separate recursive makes for
> libtraceevent.a and libtraceevent.so. Both sub-makes rebuild the same
> object files in the same output directory, which can corrupt the .o
> files and make the final link fail with file format errors.
> 
> The src/ Makefile already builds libtraceevent.so as part of the
> libtraceevent.a target. Reflect that at the top level too by making the
> shared library target depend on the static library target, so parallel
> requests for either or both libraries funnel through a single recursive
> make.
> 
> This fixes repeated `make -j8`, `make -j8 libs`, and
> `make -j8 libtraceevent.a libtraceevent.so` failures in a Linux VM,
> where the unfixed tree reproduces the race within a few runs.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=217428
> Signed-off-by: CaoRuichuang <create0818@163.com>
> ---
>  Makefile | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index e1a10a0..6649303 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -211,8 +211,7 @@ libs: libtraceevent.a libtraceevent.so
>  $(LIBTRACEEVENT_STATIC): force
>  	$(Q)$(call descend,$(src)/src,$@)
>  
> -$(LIBTRACEEVENT_SHARED): force
> -	$(Q)$(call descend,$(src)/src,libtraceevent.so)
> +$(LIBTRACEEVENT_SHARED): $(LIBTRACEEVENT_STATIC)

As you state in the change log, "Makefile already builds
libtraceevent.so as part of the libtraceevent.a target", wouldn't that
mean the above should be:

$(LIBTRACEEVENT_STATIC): $(LIBTRACEEVENT_SHARED)

$(LIBTRACEEVENT_SHARED): force
	$(Q)$(call descend,$(src)/src,libtraceevent.so)

??

BTW, thanks for working on this. Sorry I couldn't get to it earlier.

-- Steve


>  
>  $(bdir)/libtraceevent.so: $(bdir)/libtraceevent.so.$(EP_VERSION)
>  	@ln -sf $(<F) $@

