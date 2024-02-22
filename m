Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F3423747
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Feb 2024 08:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708592362; cv=none; b=shZGVRBG/MN/fn4oouuCtYwhDcW0mexzOHLAvhvHZjeGifs0Bp/UZUli5sn5FS9tJLqVBgayy3yw8WvvhJbJjyli1OQkfbTMCCs5pCp4xoW6/H18S97jzXTqGovdnsJXHp1rqxxaQd0gUzof/6dF84pOaOe59uXboaue0DzPZ18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708592362; c=relaxed/simple;
	bh=sxys+kucC2TnuN9mb34Mv1h1RFwSCyzRl+qtbkS/9jA=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=SD3OwYLoPPWXK0q3OUuMnpAbjs5jdWAdZP2j8h77UDgL/e3wy2t72MjkUofrZxzITMKpU6NrgjiYymcX/VQVLhwsmkCV/klggG09LPWJjTECjwHK+68L1V2Qn6xnXbhqRUrbv9dpgtkrctInUA/Q0OqOZWeKYuCYQRPOqumHYV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DIInGM4O; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DIInGM4O"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a3e5d82ad86so597861966b.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Feb 2024 00:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708592359; x=1709197159; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sxys+kucC2TnuN9mb34Mv1h1RFwSCyzRl+qtbkS/9jA=;
        b=DIInGM4O+3qScH7FGyy3c1lwtLeNEXpkBdJy6z9A9hI+XnESDBNXxQMuua5YAM1Fin
         /DlYr/8JLpOViPCnEW3och/t8RJcpqfTCc6eDWu+sdxF0YngwLwcsclNNZ+GB0jkvwF0
         hfibpoUEhNyWPnmqwkwhiQ+09kywFBoZB4mAv//ww7qWwWSSqRKfkWYA0m/2MyMQlDEh
         6HQhm6UMdO5fPNrPBrrgxXUDR/Ou5I29dNEdLDzNZ0Gn+ddnhHqytyhFtnWRjFe5//X+
         MdCOw2Gwogv57xtxkxMTR7/G7yYmrKAHqzkUFmdXN9ARIRvnX6RJ91Rd2iZkoUXZtAGC
         akkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708592359; x=1709197159;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sxys+kucC2TnuN9mb34Mv1h1RFwSCyzRl+qtbkS/9jA=;
        b=s1E301l0BlDaIlOdVKhC6hkb5ysrOJM5S9cZz0Z5tJ136yvoEbiNbTgMyxkGZXljG1
         hFr5g8KYWu/Nc645quXBDz6N9AbOeskbaCHH0AVFvTFh6NnyyFej/iA6VdL2B5LUisXI
         9jkNzlh6mA1t3CD76GDv17D3HlsJYou4IxVjH46YzUBfpMsIlCqr8Bg/lDQ71oBTzsE6
         BcCTxmSCzBTmkxgvDIAHPK+9OhFY5e7cUCSsaVlfXuwpyOP8qeWzlFku/thbWVH9FdGO
         V+DDDzS+M+dlnbcFUgLXJoEvmdeOZUSqoP5s1S51EJgEHNUw3DUyQUBIjdXa/wEI+P3p
         3o5Q==
X-Gm-Message-State: AOJu0YyaoMVvFre/ZtUuNVE4rSmKPk1S5uvH3OZPo71IxQYd5wRPRZsi
	ocFz6GZM5g6D5WhfsAjk7Ef/hrQhha83abL7/Whcw4M4WdHRp2ajLgaDL7x6
X-Google-Smtp-Source: AGHT+IHiWIWGQ8UXTz5gqu7EYedx15S67nKgA9rJ+KITKkmA3u8CX9S3+36nnDwsQwO/92RlHjjAqg==
X-Received: by 2002:a17:906:11d7:b0:a3e:8cb8:d819 with SMTP id o23-20020a17090611d700b00a3e8cb8d819mr10072910eja.51.1708592358772;
        Thu, 22 Feb 2024 00:59:18 -0800 (PST)
Received: from localhost (81-234-98-96-no2390.tbcn.telia.com. [81.234.98.96])
        by smtp.gmail.com with ESMTPSA id ll5-20020a170907190500b00a3f0386dc96sm2263081ejc.89.2024.02.22.00.59.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Feb 2024 00:59:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 22 Feb 2024 09:59:17 +0100
Message-Id: <CZBHFXAPE375.14HREPXS870DV@sakura.myxoz.lan>
Cc: <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/3] utest/tracefs-utest: add missing define
From: "Miko Larsson" <mikoxyzzz@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>, "Miko Larsson via B4 Relay"
 <devnull+mikoxyzzz.gmail.com@kernel.org>
X-Mailer: aerc 0.15.2
References: <20240215-utest-fixes-v1-0-24678d859de2@gmail.com>
 <20240215-utest-fixes-v1-2-24678d859de2@gmail.com>
 <20240221184937.64d71df0@gandalf.local.home>
In-Reply-To: <20240221184937.64d71df0@gandalf.local.home>

On Thu Feb 22, 2024 at 12:49 AM CET, Steven Rostedt wrote:
> FTBFS is a rather useless explanation (and I had to even look it up to fi=
nd
> out what it is ;-)
>
> The change log should show the error and explain why the change fixes the
> problem.
Heh, yeah, you're right. Thanks.
