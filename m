Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E698322EE5
	for <linux-trace-devel@vger.kernel.org>; Mon, 13 May 2024 17:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715622630; cv=none; b=e3cJWszZIxSwBqDRlDBM6t1mqS6Gt6TZhCyxBhsGHZtSeFKpitKBRx9ao5qm8NfocmLkCHBTsHd54Tro+SRzLxgE5rN/0Bo2ByuezzCN1xWd/9/JkHdpM+z6jBQE50MzOV8xfdw5BigGhHAMmIchW3ACBCm7K+5V8AirnJPasJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715622630; c=relaxed/simple;
	bh=RdleehSbZkVj8btU03L+PXPxpuMY8VypxvQY340j9nA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=luEz9KNHfmJza9IQiw/4j9B+YdfHVH0va4GwiPX/DPdeaq5CjJFuGpmoZ5tLwCmRrLWuFdv4B6I8kgTH7aI/dWz3ObNcobJp/ktzQhtskyKvOi7wFl7WjIwxsRpEqeSJOhf4sI8kW7+W19zaHDGXD+M9Ua8i97yhX49c/a+9Tnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455F1C113CC;
	Mon, 13 May 2024 17:50:30 +0000 (UTC)
Date: Mon, 13 May 2024 13:50:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Junyao Zhao <junzhao@redhat.com>, Nini Gu <ngu@redhat.com>,
 linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: support -m parameter for virt instances
Message-ID: <20240513135028.1b5fe1f9@rorschach.local.home>
In-Reply-To: <ZkJR9wJLAuEDpmR7@tpad>
References: <Zemv4OUx1WexdrlB@tpad>
	<ZkJR9wJLAuEDpmR7@tpad>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 13 May 2024 14:46:31 -0300
Marcelo Tosatti <mtosatti@redhat.com> wrote:

> Ping?

Apologies, I got totally swamped. But the priority of updating user
space tooling is getting higher, so hopefully not too long.

Thanks for you patience.

-- Steve
