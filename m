Return-Path: <SRS0=XbHK=M7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51854 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbeJSPqF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Oct 2018 11:46:05 -0400
Received: by mail-wm1-f67.google.com with SMTP id 143-v6so2614012wmf.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Oct 2018 00:41:12 -0700 (PDT)
Subject: Re: [PATCH v2 02/23] kernel-shark-qt: Add Dual Marker for KernelShark
 GUI.
To: Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
 <20181016155232.5257-3-ykaradzhov@vmware.com>
 <20181018220305.5036eedf@vmware.local.home>
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <6f403643-8a97-5dd8-6da2-72aefba3a98f@gmail.com>
Date: Fri, 19 Oct 2018 10:41:09 +0300
MIME-Version: 1.0
In-Reply-To: <20181018220305.5036eedf@vmware.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>



On 19.10.2018 05:03, Steven Rostedt wrote:
> On Tue, 16 Oct 2018 15:52:58 +0000
> Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
> 
>> +
>> +/** @brief Create a Dual Marker State Machine. */
>> +KsDualMarkerSM::KsDualMarkerSM(QWidget *parent)
>> +: QWidget(parent),
>> +  _buttonA("Marker A", this),
>> +  _buttonB("Marker B", this),
>> +  _labelDeltaDescr("    A,B Delta: ", this),
>> +  _markA(DualMarkerState::A, Qt::darkGreen),
>> +  _markB(DualMarkerState::B, Qt::darkCyan),
>> +  _scCtrlA(this),
>> +  _scCtrlB(this)
>> +{
>> +	QString styleSheetA, styleSheetB;
>> +
>> +	_buttonA.setFixedWidth(STRING_WIDTH(" Marker A "));
>> +	_buttonB.setFixedWidth(STRING_WIDTH(" Marker B "));
>> +
>> +	for (auto const &l: {&_labelMA, &_labelMB, &_labelDelta}) {
>> +		l->setFrameStyle(QFrame::Panel | QFrame::Sunken);
>> +		l->setStyleSheet("QLabel {background-color : white;}");
>> +		l->setTextInteractionFlags(Qt::TextSelectableByMouse);
>> +		l->setFixedWidth(FONT_WIDTH * 16);
> 
> As a general rule, no "magic numbers". Why 16?
> 

> 
> Don't resend this patch (I'm going to just take it). Send a patch on
> top that just replaces the hard coded numbers with meaningful macros.
> 

Hi Steven,

This is one of these cases when I disagree with you.
I don't see anything wrong with the line

l->setFixedWidth(FONT_WIDTH * 16);

or the many other lines in the code which are similar to this one.
It sets the width of the label to be 16 times the width of a typical 
character shown by Qt at the particular resolution of your screen.
The line is perfectly self-explanatory. And there is nothing magic in 
the number 16. It is just a normal number that everyone can understand 
end modify if this is necessary. Why 16? Because I tried different sizes 
and I found that this particular one looks nicer to me. If you find this 
size ugly, it is absolutist trivial to change it.

Now let's look in the alternative that you suggest (if I understand 
correctly):

l->setFixedWidth(DUAL_MARKER_TOOLBAR_LABEL_WIDTH);

This line is a magic word, because it tells you absolutist nothing about 
the actual size of this label. And if we apply this rule everywhere, we 
will need a ton of macros, with very long and in the same time very 
similar names. This will also make the geometry of the GUI completely 
hard-coded and will eliminate any possibility of making these sizes 
configurable via the Json I/O.

I do not believe in "general rules". Each rule has a field of 
applicability. When you program GUIs you need to apply fine tuning. I 
don't think we can avoid this.
Thanks!

Yordan

> Thanks!
> 
> -- Steve
> 
