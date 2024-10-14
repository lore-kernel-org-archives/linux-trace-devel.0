Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8BA1C243C
	for <linux-trace-devel@vger.kernel.org>; Mon, 14 Oct 2024 21:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728943129; cv=none; b=DMon2Jd51WaujbszQvw5+AuXSx8Z1C2fWDTk1IosW0oS7wB0tyqpLrS/0lTVaCkuGm5JjXHncasZpe5mNkBEKwZyZeL/DQ/PE1JmZFH16A+dFyrPTDCFTNwOsQxzfJZgk6wGZvWBYDzUzQcjNtvqOr93FkwLAY5Zk07QZav0HC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728943129; c=relaxed/simple;
	bh=WmXrFDRONHeTXfiOcz+nCVIl0cpSGiq2PCUCCx5W374=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gZ7R0YLa9gHNIXEgNjG5hRxu1K8NfveD0pqTPrVEfT7HBs2jdfRjzyYpshGIEjJrE/dgiplWhKcR/rfcHfsJWFQZRXHcDwM0zOZP8t5ALpKCyGu3qP40+NT/s24NN/UV7/NFykY5R9puXC4s3BnIlaoXJtZ0w6U1vNM6E1Xaz5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30502C4CEC3;
	Mon, 14 Oct 2024 21:58:48 +0000 (UTC)
Date: Mon, 14 Oct 2024 17:59:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] trace-cmd reset: Add option to preserve specific
 events
Message-ID: <20241014175905.03bec85a@gandalf.local.home>
In-Reply-To: <20241014123136.3890807-1-metin.kaya@arm.com>
References: <20241014123136.3890807-1-metin.kaya@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 14 Oct 2024 13:31:32 +0100
Metin Kaya <metin.kaya@arm.com> wrote:

> Changes since v1:
> - Update man page for -k command line parameter of "trace-cmd reset".
> - Add tab completion support for "trace-cmd reset".

Thanks, I'll go ahead and apply this. But can you do me a favor, and add a
test case to utest/tracecmd-utest.c that tests this. It should create a
each of the types, start tracing, do the reset, and make sure that the -k
keeps what is expected. Doesn't need to be too fancy.

I want to add test cases to all new features, as I'm way behind in testing
current features :-p

You don't need to send another version of this series. Just a standalone patch.

-- Steve
