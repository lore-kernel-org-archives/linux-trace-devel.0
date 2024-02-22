Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C2F154C0D
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Feb 2024 17:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708622654; cv=none; b=M4qQQg4SyzpUwxRu4ak910L7E+WFv4f5EUEpPJr9bEOhsmb1xyZMFMyHpynW5idFdYTvgOidFhljQ/G7Tv3dz7oxo3avgj1m6rJtC149PoIl2KGiACZ1UgV+q6iYIlkdSk7hTCB2CA/J9gwj5TT1ss1xFCcz2YqpQWOpOLQIOv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708622654; c=relaxed/simple;
	bh=NKaoGAZgkJnUHllWovLghTetH/ulLQoFsE5rSEqF99c=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=hMx3h4vb2jkdrDq7Xv8vLP3NEfB4xGJTgWWxB/Cv3wf+Z9Nj2JfYk/ZFhDIEEechAzgq4eVuW3b/q2kKf5sMDeo0StaAk5rqRa6kcGr26btveWWqHhVZzqVW1QZIu0hhVHI15PjndFvHGOa7rmyvd3nppmKpTbJLqYIPizuG8SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l6HageFb; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l6HageFb"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5643ae47cd3so7195835a12.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Feb 2024 09:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708622650; x=1709227450; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NKaoGAZgkJnUHllWovLghTetH/ulLQoFsE5rSEqF99c=;
        b=l6HageFbu3AlkDrY/pO8cB6Uuj42MS7hxB4QgQ37VvE3FtQkrbHHjr09INC85w8K6F
         WazkjD799qwjnWb6ChTUyVJjF2rWV6rzlUqYIvjQDTg6Y/tVY/e3SI+TCEGoRJuOUfkh
         k+9ePooPuAsXFxIwXlsNMIR6RswMBlvjdVogFXfZaw6msn7bbWay9D6Q9/tfsuhs4E3N
         WGN32nWsjARWw883Os4bCuvPou5gX+PNgjq+wpF7mN3/q5ngmdspsOhZxk9zE9QMfpR7
         Bzk8khRYJtiFmipvVQfLbabavDx0b79QukYQWG7dJj3O3PBtB5160krPWwZjrBNeVMLu
         s+zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708622650; x=1709227450;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NKaoGAZgkJnUHllWovLghTetH/ulLQoFsE5rSEqF99c=;
        b=ncPmV7l71C8XKAHedv7Hb2mYruZz7GI1QrNd9fgQ/yQ3D2ioIKCPu2bCv22vCUvFBF
         qM/hBrLWnlbRSWGA2WfQ1xLgrpOcI08YnnNVdnK8jDJ/PaJgvBh8u0odWA7hvFZhWMNS
         6UJuNIFCWa07rhbRANNS8s6/CRl09nMHPbVLyqx3Mz4eJ8xK6+SqSgLTZZM2ORS8IBim
         pgBvNkIuB4z+Lk8UjeqOaa1F2Fk7fK+t0/XdpVhQXisEezkG3TZKwwnyx5KyXDeuNxS3
         OHEacJdn+OFUMYV7/4RxfTOlD8d9aMrbFedccB6tjoufuuPp0qsBKT4do83/AgFQpwDz
         kr+Q==
X-Gm-Message-State: AOJu0YwHIVye/Wsenf4lR4Z3tFfEVyAPw4Oj604iZiXXa1zHfqRm9m0N
	ZN6S4ofguAYMdSHTUixtqDD4Te+axAjR0SKa4tQ8BRuRqwFeSf+64WkYE14j
X-Google-Smtp-Source: AGHT+IFwFhhpy44AVwjxKPNYM/UtXsx2AQ9XJbS9WFzkdGoauVH/7+df8Y0yV7zAyl/yYXJ7DtapIQ==
X-Received: by 2002:a17:906:f88a:b0:a3e:9ce3:1bb with SMTP id lg10-20020a170906f88a00b00a3e9ce301bbmr8007905ejb.3.1708622650504;
        Thu, 22 Feb 2024 09:24:10 -0800 (PST)
Received: from localhost (81-234-98-96-no2390.tbcn.telia.com. [81.234.98.96])
        by smtp.gmail.com with ESMTPSA id ha1-20020a170906a88100b00a381ca0e589sm6115828ejb.22.2024.02.22.09.24.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Feb 2024 09:24:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 22 Feb 2024 18:24:09 +0100
Message-Id: <CZBS6H2ZDU7T.1JYZ4DRUCZSJB@sakura.myxoz.lan>
From: "Miko Larsson" <mikoxyzzz@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>, "Miko Larsson via B4 Relay"
 <devnull+mikoxyzzz.gmail.com@kernel.org>
Cc: <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] utest/tracefs-utest: include linux/limits.h
X-Mailer: aerc 0.15.2
References: <20240222-utest-fixes-v2-0-ba9cd06b41d3@gmail.com>
 <20240222-utest-fixes-v2-1-ba9cd06b41d3@gmail.com>
 <20240222095345.7de30505@gandalf.local.home>
 <20240222110420.47a9c0ec@gandalf.local.home>
In-Reply-To: <20240222110420.47a9c0ec@gandalf.local.home>

On Thu Feb 22, 2024 at 5:04 PM CET, Steven Rostedt wrote:
> I'm going to apply your other two patches, but I created a patch with the
> added code above, and will be posting that shortly.
Thanks!
