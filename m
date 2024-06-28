Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4C11755C
	for <linux-trace-devel@vger.kernel.org>; Fri, 28 Jun 2024 01:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719539563; cv=none; b=OSlhYvAFDFu2GfKY9Bg6+PLmKObvyUFLPASf5jhCO+0YbCAaa+4jbTSlJX2oMAfaWKT9TbfuyXpA7BY145VdY9WDzFvqmgvdzhSKcQpvZcbWrRKwloZa0OBHU2yhGNQT7zCw2ywC0Vl6MncY56+S/zOokM3ZJWQ4NV6WpP+t+7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719539563; c=relaxed/simple;
	bh=rg1Q6gfjdEPrNLaqSsVe+ilLQPtcNgkMriYKipM75hk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=YrivU/VR17D1V9Y7+3wPB9fQSLatiq5bVCSG5KF/K9GtCBpCBqR1eQ4RxZoQA7+uvtG6nAFhXUn6U6TcLkjZ8qIYzcyx+Xb8Hw5j2kFw0KETdMHQVZ/cHoXGTDyoOiItXynnR9EjVYOjeeix6BKFvGLoJi/6GwEki8vKYlU0eJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iVgS+oto; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iVgS+oto"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e026a2238d8so65862276.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Jun 2024 18:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719539560; x=1720144360; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VBU1DmKfL3ToHAKIKSpiCLdwUieQSW5L4qnxbtfqUqM=;
        b=iVgS+otoX3Ia8Enfz49Up6DNoJmg44Fa3kcBZ1L5KSTFP8BVGJMzspQ79dvreHeaZN
         rPGYDvjll1nJ19UcHJcKGTGCsaMfvQxIUQZ+ddkzhtQhHvXZWoxDT5tnWPVts+SQMR+c
         kzCMOXzlg0dYa9DI6YN5q/G02gTjg9c3KS+aKBkyXlT8asUQ9KvRZmnr45sjvLJktGId
         8zMEJeH6i5AYVQBDfGHfOQgTnbdOfmZobMrv6mqBPMNgbyzMUgC2wYY7iJbLfjKdJMkd
         oZMp4eDpsFOVm4qdDKVzCzdQz2VimdoRmKVMtsqrffPo02Vy3jcbi40fUJiCuD4NKcXe
         M1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719539560; x=1720144360;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VBU1DmKfL3ToHAKIKSpiCLdwUieQSW5L4qnxbtfqUqM=;
        b=oUMAz6+NwRT06Qg290mjndHOrSWbwL9zzCjax7YYju4WJ+oPvPja+aVYiHXD9rzzEN
         lV6cAjMlBafpIsqUAp0OSRtsvGm1xx827pamvg2mna2n4iSrWLK9i9BOXrXo1Pfjbowu
         xuRc/GiJyU4+3+IZfRGbRElOtEblF3Ocv8EIHHtTQrdJDLepGygHBd1kalZQWhn5RjG6
         kRVXk7jqeDoABMJUK0OwuYe+bi1fa3rG34xHuHWbZxMA4f6yLVOJKoNzb1MeFvlsuhrP
         u61Oo/voYT3JvFTjKgCOQNbNQZN8cJeUg6Af2A17liAHVMKm4DeyJNhHWrx6CRj/tcBN
         K6Kg==
X-Gm-Message-State: AOJu0YysuNAyI3sVZo6SeLpYMQFFcU3nOZ2ZSsZxw9iZ3dq7mTOqkrCi
	eR0rS99PLOaowzbVQsgDrAdp+pPuKEvV3Ia5wktkERMWcRRZObM5AGfCv7LFD0efmNuQqXv4X/+
	vk6jP0zR3DmpAAlkMYtRdPzOUdmD1EQfbgggZJLnn
X-Google-Smtp-Source: AGHT+IELh28JqewvD8DNwGHS9Ss8fyvn3sC6ZlVhgmMbF/18WSERTebWIH7rRxqB8SdBgMD0dNwdv1iAh7wacjj5zqg=
X-Received: by 2002:a25:1f05:0:b0:e03:4b63:43ea with SMTP id
 3f1490d57ef6-e035d12620emr170348276.24.1719539560449; Thu, 27 Jun 2024
 18:52:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Totoro W <tw19881113@gmail.com>
Date: Fri, 28 Jun 2024 09:51:10 +0800
Message-ID: <CAFrM9zvV9oHvCpVmt3un-wMFJFoyXq7SOWTOENpDGrn_HQQDDQ@mail.gmail.com>
Subject: Re: [PATCH] fix double free issue in event_read_print_args
To: Totoro W <tw19881113@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Oops, missing the patch part, here it is:

diff --git a/src/event-parse.c b/src/event-parse.c
index 9f0522c..1f51ee9 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2375,8 +2375,6 @@ process_op(struct tep_event *event, struct
tep_print_arg *arg, char **tok)

                /* it will set arg->op.right */
                type = process_cond(event, arg, tok);
-               if (type == TEP_EVENT_ERROR)
-                       free(token);

        } else if (strcmp(token, ">>") == 0 ||
                   strcmp(token, "<<") == 0 ||
@@ -3787,7 +3785,7 @@ static int event_read_print_args(struct
tep_event *event, struct tep_print_arg *
 {
        enum tep_event_type type = TEP_EVENT_ERROR;
        struct tep_print_arg *arg;
-       char *token;
+       char *token = NULL;
        int args = 0;

        do {
@@ -3817,6 +3815,7 @@ static int event_read_print_args(struct
tep_event *event, struct tep_print_arg *
                if (type == TEP_EVENT_OP) {
                        type = process_op(event, arg, &token);
                        free_token(token);
+                       token = NULL;

                        if (consolidate_op_arg(arg) < 0)
                                type = TEP_EVENT_ERROR;
