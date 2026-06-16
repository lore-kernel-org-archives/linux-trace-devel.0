Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B4E37DE8D
	for <linux-trace-devel@vger.kernel.org>; Tue, 16 Jun 2026 20:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781642905; cv=none; b=rrozNPe/YujxXIA+NXnZcE1F4RykkCzI8Cfqgw6a7KokZJlWAFc85lMBFISoPkbIvlEqmtp7ISjRuLCU71OtanOBuZqnInC46Ci6utbLT+XzQuc6LH01G2w9YNEhAIbMfX7DIuXooRipT8uXbyxGIVlK/DSsrGpblfa4GpkL5ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781642905; c=relaxed/simple;
	bh=fsdJSilOeaIgGNtp5SwbfR/PQ+lthgMW1Xnd7NgGoG0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ywb+wCWeXzUcmYK1GObWmCK8bE15iLv+QnW27Ln6IKMojAar42iy0Yry535MOMr4B0vRk09ZDi6jDez9gNIAdifIb6E/jgLOMoXKgsEiZ6n1ZMrIwhicj+8nsyBIwoNrSa4KnLvAaZ2Lyps3QsTny9XaNNMDj3XfAocIM8w8kuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 26067120247;
	Tue, 16 Jun 2026 20:48:17 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf06.hostedemail.com (Postfix) with ESMTPA id 4C34E20011;
	Tue, 16 Jun 2026 20:48:15 +0000 (UTC)
Date: Tue, 16 Jun 2026 16:48:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: linux-trace-devel@vger.kernel.org, Emil Thorsoe <ethorsoe@tuxera.com>
Subject: Re: [PATCH] libtraceevent utest: exit test if mmap fails
Message-ID: <20260616164812.5ecda840@fedora>
In-Reply-To: <CADVatmMUERxEkbURZuZfTw+UYB2YCMVxK9nvc-z-u5kKNHxM=g@mail.gmail.com>
References: <20260526184219.408223-1-sudipm.mukherjee@gmail.com>
	<20260529144124.14954a5f@fedora>
	<CADVatmMUERxEkbURZuZfTw+UYB2YCMVxK9nvc-z-u5kKNHxM=g@mail.gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4C34E20011
X-Stat-Signature: p4g9gi6dig3zztf988bcus635q17pbzh
X-Rspamd-Server: rspamout07
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/QR8vt9x3NXTo4UeHxOOQW6Rc3m8durKk=
X-HE-Tag: 1781642895-427175
X-HE-Meta: U2FsdGVkX19OYxG7XGNJCP+P5D9/uSQ0k8Nyo8Ar96khliWYFGYFK0PhlPJcfmdo6MuoR8bECHXciCyQM+gt7i/HUa2XOEzmJyF6HYHh1uYS6MydX+c4tGybdQ4mFGWQckO6OlmPMSJzMjvPM47Rb29ZFV6jay5Ys6mfSNGOaQTUZ8NRJp1mSuTfg6vp1ekHhi3rz5/LipbUGZI2d/2NrO79WIG/8cMZT3tJncEWLXK4IdKfE5/W43JoxexuyX81UIMJ8TN4siOY9gSHSlZqTjvxDtr9n/1G0okgfWERMOwhv3ALOC5Mgm6L3OIe+1f/a3VeV59gE2bDnCGmfSiDliHMOa2aka6oUNsyCD3wjZ3x1H33qdlqzwadoeEjy57sfj3BPVvK9WSW5FA8fHwewHmLhVU1pf/0wZCVAXZzeHs0qKJU97KlMrWStobSzuQY9KtSmaRNcrWGtjH2H4bLc2UGQuCTn0Z0nHRDNPtqqdU=

On Mon, 15 Jun 2026 20:25:08 +0100
Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:

> Hi Steve,
> 
> On Fri, 29 May 2026 at 19:41, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Tue, 26 May 2026 19:42:19 +0100
> > Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> >  
> > > CU_TEST() continues execution even if the test fails. It just records
> > > that the test has failed and moves on.
> > > So, when libtraceevent is built in a chroot, it can open
> > > /sys/kernel/btf/vmlinux but fails in mmap stage and since CU_TEST()
> > > does not stop so we get a segfault when tep_load_btf() tries to use
> > > the mapped buffer.
> > >
> > > Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>  
> >
> > Thanks, but the real fix is here and I'm applying that one:
> >
> >   https://lore.kernel.org/all/d6e07cd6-cb78-4119-a048-920ca58b4830@tuxera.com/  
> 
> Tried it today, and the test still fails for me.

Thanks for letting me know. I currently just started a new job and I'm
a bit overwhelmed. It may be a couple more weeks before I get to this.

-- Steve
