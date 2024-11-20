Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C2928EC
	for <linux-trace-devel@vger.kernel.org>; Wed, 20 Nov 2024 03:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732075060; cv=none; b=jLosmkHYmpsvmTCzHQWzYwKZM5JJwbkeKVWoBd9KtFhgmcYiwL4UBnQ2uWDd25JwxdL8LqQEMrjbo1PRqqazwXV+EV9Bx74ZkDBNzt7r6e46ye9azXV9sp1o5+vtYzYTe2go6nXfPjmldABMdB/JV3r8yePLuTv9dUVqCSILGJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732075060; c=relaxed/simple;
	bh=F39kGf7Uvu9GT/9bcznQ0/kluWOCGbmkMXGnjxWih4g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oApRrimjys2rb8+WSNlt5yQMeE8kR70LEqN3GsvHAC87wre7Lu9pj+Jn83pWVUbuuUlfuAaOkPXU6eY+2G9AdEJx+cDa82hrekpExCzBpwjB23nlDVnFSdotUL2pBr88qG5ypjUOSLJdZVoLBxVf/+lT+x9zugv1xkdmLEipcrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79894C4CECD;
	Wed, 20 Nov 2024 03:57:39 +0000 (UTC)
Date: Tue, 19 Nov 2024 22:57:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Destroy synthetic and eprobes before other
 events
Message-ID: <20241119225737.1a19a573@rorschach.local.home>
In-Reply-To: <cf4686b0-5e1e-4839-9484-7611e288f4b7@arm.com>
References: <20241016123552.55efa78f@gandalf.local.home>
	<e6ddd9b6-ce83-451e-8344-24ff620245cc@arm.com>
	<20241017160108.4f99c917@gandalf.local.home>
	<6c67124d-a806-42d6-a2c5-a74cccb4fce3@arm.com>
	<20241018101751.76f6886f@gandalf.local.home>
	<cf4686b0-5e1e-4839-9484-7611e288f4b7@arm.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 18 Oct 2024 15:51:20 +0100
Metin Kaya <metin.kaya@arm.com> wrote:

> I've these patches in my stash:
> 
> * 8468f2e - (HEAD -> libtracefs) libtracefs utest: Add debug logs <Metin 
> Kaya>  
> * cee05c1 - libtracefs utest: Do not test more events than what the ring 
> buffer can hold <Steven Rostedt (Google)>
> * 385650c - libtracefs utest: Fix min percent test <Steven Rostedt (Google)>
> * c0810b9 - libtracefs utest: Add test to check handling multiple 
> dynamic events <Steven Rostedt (Google)>
> * d8fcfff - libtracefs: Destroy synthetic and eprobes before other 
> events <Steven Rostedt (Google)>
> * 78d8d2e - (origin/libtracefs, origin/HEAD) libtracefs: Have 
> tracefs_dynevent_get_all() find kprobes and uprobes properly <Steven 
> Rostedt (Google)>

I haven't applied this patch yet (but plan to). Is this still an issue
for you?

-- Steve
