Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745F734EF04
	for <linux-trace-devel@vger.kernel.org>; Wed, 26 Aug 2026 20:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787776611; cv=none; b=gmt4xlZpVJH+eAMv5eBnLKzVdgAf9cSEwVVnEb2IROL37URg69dBg+QCBK5ZE48z1/EHMDhPEd9DA0+f1Ru6mbHET4BFzdF/DbqQ4fBng/D5w1JwnuJzhC6IgVVbwtEQQOOX2QZYPSjwFAfOgsIuUbLCK3oMdFlWk4TfdE6J9mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787776611; c=relaxed/simple;
	bh=GLPNbGEPbtNmhTrDysQuFla0Sx927tRTlurl0sudEyc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g0pWF98QVdS39hiZyXuzz0MF5tLCv7m86Etg97eREmo4dopO5UreMdhB4C1m+kqKQzG0BiT0b1wmZPOIx3JG0n6uSym4QoZOW/+ns6z7wgqRVPemX3YUrtKHZAmojBr78elQLPE3/+oXFKzLY3z4fgCkVeniOFkMOgJiv4vamrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.b=rzp2rTN1; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.b="rzp2rTN1"
Received: from omf20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 49EAAA3259;
	Wed, 26 Aug 2026 20:36:42 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id CDDB320029;
	Wed, 26 Aug 2026 20:36:40 +0000 (UTC)
Date: Wed, 26 Aug 2026 16:37:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Benjamin Drung <benjamin.drung@canonical.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] libtracefs: Use LIBTRACEFS_STATIC for utest
Message-ID: <20260826163726.1fe4677a@gandalf.local.home>
In-Reply-To: <20260605145309.2586533-1-benjamin.drung@canonical.com>
References: <20260605145309.2586533-1-benjamin.drung@canonical.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CDDB320029
X-Stat-Signature: 7p831jzkrdbpo4myxkmt4ej5g5qfs6bj
X-Rspamd-Server: rspamout07
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19bOo3bFmaSowjC+f8bV/y42RW3IClrmFE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=M3N4qAVId2ee9ZOsDZH6SvQBVKAuMrsx0ZC0GZLMHVk=; b=rzp2rTN10evk0HFcVTRbibR41HZSdxC7IMP7TBHvbfis2NK/YWxbkVg8F6dBcu3BANYta69VLVt6NLp3syXW1jf0fpCjfCsdf7UBcK+cHlQ0x/cpu7t/tHH3jsyAWTINpAsmgJaoCck0a1F1NDqSwiAV22iZ0kct0v4+6SmTmXQ=
X-HE-Tag: 1787776600-233958
X-HE-Meta: U2FsdGVkX1/HAmLkhwloWlQmoQLv7bpBXwU3CipQB9fKp64IWhwwI/3LbQ3qMlL7Tp4cQlNtS4DhanyatwsPAX283DEvGL8CSMU7AZ67iCWo7967LkwjINpiXEn4sE2eag8x0AOqKLdFAG4xo+4tscOb+REcGR3Wj+quNXxZTiJcN4JYp2hBGPZdOssBz7gy0hJnP9IDuf1P4k8/x6aDCCQOUAbpB94thTNWt+5rH+e0EuhG0hC4Rgje6oaHOOTfvLBeGl82hljYIir9v0eB6xEWx3uEkHqT3PDoQw9AFuRlqZCvMlSp6gVPZogCSuvhu8K5EugE/0J8+9iVGmABKwHivyWcI7aBiwhsoQ1s4atRKnoC1JXBftZEH6eHhZ1x


Sorry for the late reply. I finally have time to look at these patches.

They look fine but both of them are missing your Signed-off-by. I can't
take them without that.

Thanks,

-- Steve


On Fri, 05 Jun 2026 14:53:21 +0000
Benjamin Drung <benjamin.drung@canonical.com> wrote:

> The top-level Makefile already sets `LIBTRACEFS_STATIC`. To allow
> overriding the static libtracefs library using just this variable, use
> `LIBTRACEFS_STATIC` in the utest Makefile as well.
> ---
>  utest/Makefile | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/utest/Makefile b/utest/Makefile
> index f10b709..9bd3dea 100644
> --- a/utest/Makefile
> +++ b/utest/Makefile
> @@ -10,9 +10,11 @@ OBJS =
>  OBJS += trace-utest.o
>  OBJS += tracefs-utest.o
>  
> +LIBTRACEFS_STATIC ?= $(obj)/lib/libtracefs.a
> +
>  LIBS += -lcunit				\
>  	-ldl				\
> -	$(obj)/lib/libtracefs.a
> +	$(LIBTRACEFS_STATIC)
>  
>  OBJS := $(OBJS:%.o=$(bdir)/%.o)
>  
> @@ -21,7 +23,7 @@ $(bdir):
>  
>  $(OBJS): | $(bdir)
>  
> -$(bdir)/trace-utest: $(OBJS) $(obj)/lib/libtracefs.a
> +$(bdir)/trace-utest: $(OBJS) $(LIBTRACEFS_STATIC)
>  	$(Q)$(do_app_build)
>  
>  $(bdir)/%.o: %.c

