Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FF4466B44
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2026 18:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780080089; cv=none; b=XO7OY4fLvn6Zj/zQeosLDh2hav2pnUM/GvRusKOUpB9mGTD0TJX0IFuJPrVaKm2YKZpIhET0arqojdxAa/imA/KPNcZDpIDK4Nvb/u8ZeFe6GYHwWAhxbmjKOirA0iqdXqUpj8vBluWAz1E0bxXz2A40ni6YNQKnekFltxD7Kwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780080089; c=relaxed/simple;
	bh=UP1U6nhIs4Fl+zjJBB7FTZaG297BNkQvY/KFPdpHcp8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lgMhIcIAW8hyydFP2bfDrziHd6XdvxCbFEViVJKSndKBN7E29muCKlejgasTVgS+UVqgL8xdU1l/gvjQmSbPwn3459pbeD49+aE4fV18O0X269s3j98SnTCu1zsbE7wK3PlUxN5f7md9KxE4OEF4xCPsN4b0FBcrJdxXx70hDno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3F868CCCC;
	Fri, 29 May 2026 18:41:26 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id 5714E2002A;
	Fri, 29 May 2026 18:41:25 +0000 (UTC)
Date: Fri, 29 May 2026 14:41:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: linux-trace-devel@vger.kernel.org, Emil Thorsoe <ethorsoe@tuxera.com>
Subject: Re: [PATCH] libtraceevent utest: exit test if mmap fails
Message-ID: <20260529144124.14954a5f@fedora>
In-Reply-To: <20260526184219.408223-1-sudipm.mukherjee@gmail.com>
References: <20260526184219.408223-1-sudipm.mukherjee@gmail.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5714E2002A
X-Rspamd-Server: rspamout06
X-Stat-Signature: h41u6o53woks8hogngff9iazdbax9qtg
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+BycADcp7VU7gdwNRH5hPUM7MMKWJrjdA=
X-HE-Tag: 1780080085-342252
X-HE-Meta: U2FsdGVkX1/ZBaCJsvlpdhvVGWebMTtZF/6euhX4BrWSoxu6Pk/x5MfwBX7bzN0QfC+RCszwz4lVNW0R/VviEfrvG0tgyiVVmSPyvvNzMs3YCb3rbl0ZqlYBNcXvqPqmhYacwivSJhAU8zFPSf96C4Voy5yNiGdAKFXRCBKE31ZrUR+d0hoH7XkveQXe5Z26tsLgBV7XcIMgk5RXp6I440QSr3iLVqMCRglr1eJ5Bczs0ehRsgYh2e5yWLFCmBQ/4EMlda1Vt44yfE8JbfNQwEJJ8irPdyHnoo8/YhJjT2kZZLSa375QcUVA7Zks8aZ/VzJoZ4YsiDDm65P557OlrOok7gFPbmS1Nzup7RmVHUbGI8prInhW4BQpodM5t12bjNx6TDMY1eoDyXGKycH+3w9C05TvYM09vUsjfEVzKyY=

On Tue, 26 May 2026 19:42:19 +0100
Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:

> CU_TEST() continues execution even if the test fails. It just records
> that the test has failed and moves on.
> So, when libtraceevent is built in a chroot, it can open
> /sys/kernel/btf/vmlinux but fails in mmap stage and since CU_TEST()
> does not stop so we get a segfault when tep_load_btf() tries to use
> the mapped buffer.
> 
> Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

Thanks, but the real fix is here and I'm applying that one:

  https://lore.kernel.org/all/d6e07cd6-cb78-4119-a048-920ca58b4830@tuxera.com/

-- Steve
